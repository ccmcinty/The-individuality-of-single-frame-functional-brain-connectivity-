function [status, message, messageid] = wfu_mkdir(dirName)
%
% PURPOSE:  Makes the directory requested even if the parent directory does not exits.  
%           This function mimics the behaviour of Matlab's mkdir in version 7.
%
% CATEGORY: Utility
%
% INPUTS: 
%
%       dirName

%
% RETURN PARAMETERS:
%
%       SUCCESS:   logical scalar, defining the outcome of MKDIR. 
%                  1 : MKDIR executed successfully. 0 : an error occurred.
%       MESSAGE:   string, defining the error or warning message. 
%                  empty string : MKDIR executed successfully. mescsage :
%                  an error or warning message, as applicable.
%       MESSAGEID: string, defining the error or warning identifier.
%                  empty string : MKDIR executed successfully. message id:
%                  the MATLAB error or warning message identifier (see
%                  ERROR, LASTERR, WARNING, LASTWARN).  
%
% EXAMPLE:
%
%

%==========================================================================
% C H A N G E   L O G
% 
%--------------------------------------------------------------------------

% $Id: wfu_mkdir.m,v 1.2 2009/10/26 15:47:22 bkraft Exp $ 

% $Log: wfu_mkdir.m,v $
% Revision 1.2  2009/10/26 15:47:22  bkraft
% Updating LCBN repository with WFUbk updates
%
% Revision 1.10  2007/05/17 19:05:12  bkraft
% Fixed Matlab 6 bug.
%
% Revision 1.9  2006/03/17 16:13:11  bkraft
% Minor bug for Matlab 7 fixed.
%
% Revision 1.8  2006/01/26 19:22:42  bkraft
% Check to see if the directory already exists before making it to avoid warnings.
%
% Revision 1.7  2006/01/12 20:20:40  bkraft
% Added missing semicolon.
%
% Revision 1.6  2005/12/27 18:38:34  bkraft
% Added missing semicolons to suppress displaying directories to matlab output.
%
% Revision 1.5  2005/12/27 18:34:35  bkraft
% Fixed function to work correctly under Matlab 6.
%
% Revision 1.4  2005/12/09 19:28:50  fmri
% Small enhancements made to each file.
%
% Revision 1.3  2005/11/14 21:40:26  bkraft
% Found some bugs during merge testing. Updating repository
%
% Revision 1.2  2005/11/14 15:05:26  bkraft
% Cosmetic changes.
%

v             = ver('Matlab');
versionMatlab = str2num(v.Version(1));


if versionMatlab >= 7

    fullDirName = wfu_get_full_path(dirName);

    if( ~exist(fullDirName,'dir') == true)
        [status, message, messageid] = mkdir(dirName);
    end

else

    %
    % Get Full Path
    %

    dirName = wfu_get_full_path(dirName);
    dirName = strcat(dirName,filesep);

    %
    % Find the location of the directory
    %
    filesepPosition = findstr(dirName,filesep);
    nFilesepPosition = length(filesepPosition);


    for ii=1:nFilesepPosition-1

        parentDirName = dirName(1:filesepPosition(ii));
        subDirName    = dirName(filesepPosition(ii)+1:filesepPosition(ii+1)-1);
        fullDirName   = strcat(parentDirName, subDirName);

        if( ~exist(fullDirName,'dir') == true)
            [status, message, messageid] = mkdir(parentDirName, subDirName);
        end
    end
end