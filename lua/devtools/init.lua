local function CommandAccess( ply )
    return IsValid( ply ) and ply:IsSuperAdmin() and ply:IsFullyAuthenticated() or ply:IsListenServerHost()
end

local function FindPlayerByNickname( nick )
    for num, pl in ipairs( player.GetAll() ) do
        if pl:Nick():match( nick ) then
            return pl
        end
    end
end

local function FindTargets( ply, args )
    local players = {}
    for num, nick in ipairs( args ) do
        local pl = FindPlayerByNickname( nick )
        if IsValid( pl ) then
            table.insert( players, pl )
            break
        end
    end

    if (#players < 1) then
        local ent = ply:GetEyeTrace().Entity
        if IsValid( ent ) and ent:IsPlayer() or ent:IsNPC() then
            table.insert( players, ent )
        elseif IsValid( ply ) then
            table.insert( players, ply )
        end
    end

    return players
end

local function StripWeapon( ply, wep )
    if IsValid( wep ) then
        wep:Remove()
        ply:SelectWeapon( table.Random( ply:GetWeapons() ) )
        MsgN( tostring( ply ) .. " striped weapon: " .. tostring( wep ) )
    end
end

concommand.Add("strip_weapons", function( ply, cmd, args )
    if CommandAccess( ply ) then
        for num, pl in ipairs( FindTargets( ply, args ) ) do
            for num, wep in ipairs( pl:GetWeapons() ) do
                StripWeapon( pl, wep )
            end
        end
    end
end)

concommand.Add("strip_active_weapon", function( ply, cmd, args )
    if CommandAccess( ply ) then
        for num, pl in ipairs( FindTargets( ply, args ) ) do
            StripWeapon( pl, pl:GetActiveWeapon() )
        end
    end
end)