function dnames = wfu_find_dirs(regExpression, searchDirectories,recurseDepth, options )
%
% PURPOSE:   Finds all files matching the regular expression in the specified 
%            directory and subdirectories (recursive). Returns a cell array
%            with the fully specified file names.
%
% CATEGORY: Utility
%
% INPUTS: regExpression - A regular expression. For more information search
%                         for Regular Expression in Matlab help.
%
%         searchDirectories - List of directories to search. Default is
%                             current directory.
%
%         recurseDepth - Depth of recursive search.  If the depth flag is
%                        0 or false then only current directory is searched. If flag is true
%                        then directories up to 256 deep are searched. If the recurseDepth
%                        is a positive number than directories are searched to that
%                        directory depth.
%         
% KEYWORD PARAMETERS:
%
%         options.displayFiles - Prints out a list of files found in order.
%
%         options.displayDirectories - Prints out a list of directories
%                                      where files were found that matched 
%                                      the regular expression.
%
% OUTPUTS: 
%
%    fnames - List of Files that match regular expression.
%    dnames - List of Directories containing files that match the regular
%             expression.
%
% EXAMPLE:
%
%    files = wfu_find_dirs
%       Finds all the directories in the current path.
%
%
%
%  Known Issues and Bugs:
%
%     Searching directories recursively does not work.
%
%
%
% $Id: wfu_find_dirs.m,v 1.2 2009/11/17 12:57:31 bkraft Exp $

% $Log: wfu_find_dirs.m,v $
% Revision 1.2  2009/11/17 12:57:31  bkraft
% Superficial changes. Updated comments and output display.
%
% Revision 1.1.1.1  2009/10/22 16:56:39  bkraft
% \T\r\a\n\s\f\e\r\r\i\n\g\ \f\i\l\e\s\ \f\r\o\m\ \A\N\S\I\R\ \t\o\ \L\C\B\N
%
% Revision 1.3  2009/08/26 15:48:31  bkraft
% Updated files to fix bug searching for directories
%
% Revision 1.2  2007/05/17 14:35:39  bkraft
% Fixed display bug
%
% Revision 1.1  2007/03/24 09:21:29  bkraft
% Modified these files to support searching for directories that match a regular expression.
%
% Revision 1.9  2006/10/03 20:58:30  bkraft
% Added the ability to display search progress via an option.
%
% Revision 1.8  2006/01/27 14:41:53  bkraft
% Added some logic to control the recursion depth better.
%
% Revision 1.6  2005/10/11 12:39:30  bkraft
% Fixed bug in specifying the recursion depth correctly.  Added better comments.
%
% Revision 1.5  2005/10/06 14:35:08  bkraft
% Added functionality to display directories.
%
% Revision 1.4  2005/07/12 16:16:15  bkraft
% Changed default of listing directories to false.
%
% Revision 1.3  2005/04/22 19:43:39  bkraft
% Recursion limit incorrectly set. The bug was fixed so recursion by default is now off.
%
% Revision 1.2  2004/12/06 03:01:48  bkraft
% Allow the first input argument to contain a list of directories to search.
%
% Revision 1.1  2004/11/03 14:25:07  bkraft
% wfu_find_files has been moved from the WFU_geToolbox to here so that it can be used by the entire BPM project
%
% Revision 1.1.1.1  2004/11/02 18:09:06  bkraft
% Initial BPM import
%
% Revision 1.1  2004/11/02 18:02:10  bkraft
% Added the ability to return a list of directories.
%
% Revision 1.2  2004/10/25 17:24:05  bkraft
% Updated merge of files for 11.0 platform.  This working directory has been tested 
% to work after a checkout. All dependecies have been resolved.
%
% Revision 1.1  2004/10/25 16:38:51  bkraft
% Added a function to find the pfiles in a current directory and return a cell list.
%

%
% Call wfu_find_files_recursive to generate list
%

%
% Set options
%

recursionMaximumDepth = 256;

defaultOptions = struct('recursionDepth',0,'recursionMaximumDepth',recursionMaximumDepth, ...
                        'displayFiles', false, 'displayDirectories', true, ...
                        'displayProgress', false, 'findDirectories',true);

if nargin < 4	
    options = [];
end

options = wfu_set_function_options(options,defaultOptions);

%
% Set input parameters if they are not defined
%

startingDirectory = pwd;

if nargin < 1 || isempty(regExpression)
    regExpression = '.*';
end

if nargin < 2 || isempty(searchDirectories)
    searchDirectories = startingDirectory;
end

if nargin < 3 || isempty(recurseDepth) || (recurseDepth == false)
    recurseDepth = 0;
end

if islogical(recurseDepth) && (recurseDepth == false)
    options.recursionMaximumDepth = 0;
end

if islogical(recurseDepth) && (recurseDepth == true)
    options.recursionMaximumDepth = recursionMaximumDepth;    
end

if isnumeric(recurseDepth) && recurseDepth >= 0
    options.recursionMaximumDepth = recurseDepth;
end



if ~iscell(searchDirectories)
    searchDirectories = {searchDirectories};
end

%
%
%

fileOptions = options;

fileOptions.displayFiles       = true;
fileOptions.displayDirectories = false;
fileOptions.findDirectories    = true;

[dnames parentDirectories] = wfu_find_files(regExpression, searchDirectories, recurseDepth, fileOptions );
