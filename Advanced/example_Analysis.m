function retstr = example_Analysis(instruct)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Short description of example:
%
% TOPIC: "Insert topic here"
% CHAPTER: "Insert chapter here"
% EXAMPLE: example_name
% ID: name
% KEYWORDS: "Insert keywords here"
% DESCRIPTION: "Insert short description here"
% AUTHORS: "Insert authorname(s)"
% LAST UPDATE: "Insert date of last changes here"
% BY: "Insert name of last modifyer"
%
% Part of the MMT E-Learning Platform by ASC-MMS and DWH.
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%% EXTRACTION OF INPUT VALUES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input values from the web-interface must be extracted from a text string.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extraction of input variables from a text string.
a=str2num(instruct.var1);


%================================= END OF SPECIFIC CODE - CUT HERE ========
%% CONSTANT VARIABLES AND PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Constant variables and parameters are defined in this section.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CALCULATIONS, FUNCTION CALLS AND MAIN PROGRAM %%%%%%%%%%%%%%%%%%%%%%%%%%
% All general calculations and operations come here.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GRAPHICAL OUTPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Graphical output is generated here.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Pic = figure('visible','off');
% disables graphical output on the remote system. Switch ’on’ at home.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%================================= BEGIN OF SPECIFIC CODE - CUT HERE ======
r=adamInitialize();
r=adamRenderImage(r,instruct,Pic,'Insert imagetitle here');
% produces a *.png image for graphical output.
r=adamRenderText(r,instruct,'Insert textoutput here','Insert texttitle here');
% produces textual output.
retstr=adamComposeResultString(r);
%================================= END OF SPECIFIC CODE - CUT HERE ========
%================================= BEGIN OF SPECIFIC CODE - CUT HERE ======
%% END OF EXAMPLE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%