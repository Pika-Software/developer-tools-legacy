local AddCSLuaFile = AddCSLuaFile
local include = include
local Color = Color
local CLIENT = CLIENT
local SERVER = SERVER
local MsgC = MsgC

do
    module( "dev_tools" )

    local white_grey = Color( 200, 200, 200 )
    local side_color = CLIENT and Color( 255, 150, 0 ) or Color( 0, 150, 255 )

    function Log( str, ... )
        str = str .. "\n"
        MsgC( side_color, "[Dev Tools] ", white_grey, str:format( ... ) )
    end
end

local folder = "devtools/"
if SERVER then
    AddCSLuaFile( folder .. "cl_init.lua" )
    AddCSLuaFile( folder .. "shared.lua" )
    include( folder .. "init.lua" )
end

if CLIENT then
    include( folder .. "cl_init.lua" )
end

include( folder .. "shared.lua" )
