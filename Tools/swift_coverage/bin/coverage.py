import os
import sys
import io
import subprocess
import re

XCPATH = subprocess.check_output(['xcode-select', '--print-path']).strip()
FWPATH = re.sub(r'/Developer$', r'/SharedFrameworks/LLDB.framework/Resources/Python', XCPATH).strip()
sys.path.insert(0, FWPATH)
import lldb

debugger = None

class CoverageData:
    def __init__(self, line, count):
        self.line = line
        self.count = count

class CoverageFile:
    def __init__(self, filename):
        self.filename = filename
        self.lines = []
        self.coverages = {}
        self.run_count = 1
        self.program_count = 1

    def add_line(self, line):
        self.lines.append(line)

    def set_hit_count(self, line_number, hit_count):
        coverage_data = CoverageData(self.lines[line_number], hit_count)
        self.coverages[str(line_number)] = coverage_data

    def coverage_data(self, index):
        coverage_data = self.coverages.get(str(index), None)
        if not coverage_data:
            coverage_data = CoverageData(None, None)
        return coverage_data

    def filename(self):
        return self.filename

    def lines(self):
        return list(self.lines)

    def number_of_lines(self):
        return len(self.lines)

    def run_count(self):
        return self.run_count

    def program_count(self):
        return self.program_count

def setup_breakpoints(target, source_root):
    coverage_files = {}
    for file in fild_all_files(source_root):
        if file.endswith('.swift') and not file.endswith('Tests.swift'):
            coverage_file = CoverageFile(file)
            coverage_files[file] = coverage_file

            for line_number, line in enumerate(open(file)):
                coverage_file.add_line(line.rstrip())

                breakpoint = target.BreakpointCreateByLocation(file, line_number)
                breakpoint.SetScriptCallbackFunction('breakpoint_callback')

    return coverage_files

first_launch = True
def breakpoint_callback(frame, location, dict):
    global debugger
    global first_launch

    if os.getenv('SWIFTCOV_HIT_COUNT', 'NO') != 'YES':
        location.SetEnabled(False)

    if first_launch:
        first_launch = False
        disable_unnecessary_breakpoints(debugger.GetSelectedTarget())

    return False

def disable_unnecessary_breakpoints(target):
    for breakpoint in target.breakpoint_iter():
        if breakpoint.GetNumLocations() == 0:
            breakpoint.SetEnabled(False)

        for location in breakpoint:
            address = location.GetAddress()
            line_entry = address.GetLineEntry()
            file_spec = line_entry.GetFileSpec()

            filename = file_spec.GetFilename()
            if filename is None or filename == '<unknown>':
                breakpoint.SetEnabled(False)
                continue

def collect_coverage_data(target, coverage_files):
    for breakpoint in target.breakpoint_iter():
        for location in breakpoint:
            address = location.GetAddress()
            line_entry = address.GetLineEntry()
            file_spec = line_entry.GetFileSpec()

            filename = file_spec.GetFilename()
            if filename is None or filename == '<unknown>':
                continue

            path = file_spec.__get_fullpath__()
            line_number = line_entry.GetLine()
            hit_count = breakpoint.GetHitCount()

            coverage_file = coverage_files[path]

            if line_number > 0 and line_number < coverage_file.number_of_lines():
                coverage_file.set_hit_count(line_number, hit_count)

def report_caverage(coverage_files, output_dir):
    for filename in coverage_files:
        report = []
        coverage_file = coverage_files[filename]

        report.append('%s:%s:Source:%s' % ('-'.rjust(5), '0'.rjust(5), coverage_file.filename))
        report.append('%s:%s:Runs:%d' % ('-'.rjust(5), '0'.rjust(5), coverage_file.run_count))
        report.append('%s:%s:Programs:%d' % ('-'.rjust(5), '0'.rjust(5), coverage_file.program_count))

        for index, line in enumerate(coverage_file.lines):
            coverage_data = coverage_file.coverage_data(index + 1)
            count = ''
            if line.strip() == '}': # False positive
                count = '-'
            elif coverage_data.count is None:
                count = '-'
            elif coverage_data.count == 0:
                count = '#####'
            else:
                count = str(coverage_data.count)

            report.append('%s:%s:%s' % (count.rjust(5), str(index + 1).rjust(5), line))

        report_filename = os.path.basename(filename)
        report_path = os.path.join(output_dir, report_filename + '.gcov')

        with io.open(report_path, mode = 'wb') as fh:
            fh.write('\n'.join(report))

def fild_all_files(directory):
    for root, dirs, files in os.walk(directory):
        yield root
        for file in files:
            yield os.path.join(root, file)

def main():
    global XCPATH
    global debugger

    if len(sys.argv) != 4:
        print('usage: python coverage.py <target> <sourceroot> <outputdir>')
        sys.exit(1)

    target_path = sys.argv[1]
    source_root = sys.argv[2]
    output_dir = sys.argv[3]

    debugger = lldb.SBDebugger.Create()
    debugger.SetAsync(False)

    sdk_name = os.getenv('SWIFTCOV_SDK_NAME')

    if sdk_name.startswith('iphone'):
        xctest_path = os.path.join(XCPATH, 'Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk/Developer/usr/bin/xctest')
        target = debugger.CreateTarget(xctest_path)
    else:
        xctest_path = subprocess.check_output(['xcrun', '-sdk', sdk_name, '--find', 'xctest']).strip()
        target = debugger.CreateTarget(xctest_path)

    if not target:
        print 'Failed to create target'
        sys.exit(1)

    debugger.SetSelectedTarget(target)

    coverage_files = setup_breakpoints(target, source_root)

    if os.getenv('SWIFTCOV_SDK_NAME').startswith('iphone'):
        environment = ['DYLD_FRAMEWORK_PATH=%s' % os.getenv('SWIFTCOV_DYLD_FRAMEWORK_PATH'),
                       'DYLD_LIBRARY_PATH=%s' % os.getenv('SWIFTCOV_DYLD_LIBRARY_PATH'),
                       'DYLD_FALLBACK_FRAMEWORK_PATH=%s' % os.getenv('SWIFTCOV_DYLD_FALLBACK_FRAMEWORK_PATH'),
                       'DYLD_FALLBACK_LIBRARY_PATH=%s' % os.getenv('SWIFTCOV_DYLD_FALLBACK_LIBRARY_PATH'),
                       'DYLD_ROOT_PATH=%s' % os.getenv('SWIFTCOV_DYLD_ROOT_PATH'),
                       'LC_ALL=en_US.UTF-8']
    else:
        environment = ['DYLD_FRAMEWORK_PATH=%s' %  os.getenv('SWIFTCOV_DYLD_FRAMEWORK_PATH'),
                       'DYLD_LIBRARY_PATH=%s' %  os.getenv('SWIFTCOV_DYLD_LIBRARY_PATH'),
                       'LC_ALL=en_US.UTF-8']

    launch_error = lldb.SBError()
    process = target.Launch(debugger.GetListener(),
                            ['-XCTestInvertScope', 'YES', '-XCTest', target_path],
                            environment,
                            os.ctermid(),
                            os.ctermid(),
                            os.ctermid(),
                            os.getcwd(),
                            lldb.eLaunchFlagNone,
                            False,
                            launch_error
                           )

    collect_coverage_data(target, coverage_files)
    report_caverage(coverage_files, output_dir)

if __name__ == '__main__':
    main()
