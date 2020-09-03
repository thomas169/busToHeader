function sortBusHeader(headerPath)
% *************************************************************************
% File:         <a href="matlab:amp('sortBusHeader.m')">sortBusHeader.m</a>
%
% Functions:    sortBusHeader(headerPath)
%
% Description:  Sort the header file so typedef dependancies are resolved.
%               It's a wrapper function of busToHeader. As the sort can be
%               slow this seperate function can be called as needed.
%
% Arguments:    headerPath:
%                   name of the header file to write or append.
%
% Useage:       sortBusHeader('busDefs.h')
%               busToHeader([], 'busDefs.h', [], [], true) % eqivalent
%
% Revisions:    1.00 01/09/20 (tf) first release
%
% See also:     busToHeader
%
% SPDX-License-Identifier: Apache-2.0
% *************************************************************************

%% sortBusHeader

assert(exist(headerPath, 'file') == 2, 'File not found')
busToHeader([], headerPath, [], [], true)

end