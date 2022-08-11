do
    module( "dev_tools", package.seeall )

    SV = 0
    CL = 1
    -- SH = SV + CL

    local modules = {}
    function AddWebModule( name, url, run_side )
        table.insert( modules, { url, name, run_side } )
    end

    local function LoadWebModule( url, name, run_side )
        if run_side and (run_side < 2) then
            if SERVER and run_side == 1 then return end
            if CLIENT and run_side == 0 then return end
        end

        local start = SysTime()
        http.Fetch(url, function( body, size, headers, code )
            if (code == 200) or (code == 0) and isstring( body ) and size > 0 then
                Log( "Web module %s downloaded succesfully, size %s KB, took %.4f seconds.", name, tostring( size / 1024 / 1024 ), SysTime() - start )
                local func = CompileString( body )
                if isfunction(func) then
                    local ok, err = pcall( func )
                    if (ok) then
                        Log( "Web module %s included succesfully!", name )
                    else
                        Log( "Web module %s include failed, error: %s.", name, err )
                    end

                    return
                end
            end

            Log( "Web module %s include failed, error: %s.", name, "Compilation failed - unknown error" )
        end, function( err )
            Log( "Web module downloading error: %s ", err )
        end)
    end

    timer.Simple(0, function()
        for num, data in ipairs( modules ) do
            LoadWebModule( data[1], data[2] )
        end
    end)
end

dev_tools.AddWebModule( "VGUI Cleanup", "https://raw.githubusercontent.com/PrikolMen/gmod_vgui_cleanup/main/lua/autorun/client/cl_vgui_cleanup.lua", dev_tools.CL )
dev_tools.AddWebModule( "gm_reset", "https://raw.githubusercontent.com/PrikolMen/gm_reset/main/lua/autorun/server/gm_reset.lua", dev_tools.SV )
