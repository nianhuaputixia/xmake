--!The Automatic Cross-platform Build Tool
-- 
-- XMake is free software; you can redistribute it and/or modify
-- it under the terms of the GNU Lesser General Public License as published by
-- the Free Software Foundation; either version 2.1 of the License, or
-- (at your option) any later version.
-- 
-- XMake is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU Lesser General Public License for more details.
-- 
-- You should have received a copy of the GNU Lesser General Public License
-- along with XMake; 
-- If not, see <a href="http://www.gnu.org/licenses/"> http://www.gnu.org/licenses/</a>
-- 
-- Copyright (C) 2009 - 2015, ruki All rights reserved.
--
-- @author      ruki
-- @file        prober.lua
--

-- load modules
local os        = require("base/os")
local path      = require("base/path")
local utils     = require("base/utils")
local string    = require("base/string")

-- define module: prober
local prober = prober or {}

-- probe the architecture
function prober._probe_arch(configs)

    -- get the architecture
    local arch = configs.arch

    -- ok? 
    if arch then return true end

    -- init the default architecture
    configs.arch = xmake._ARCH

    -- ok
    return true
end

-- probe the ccache
function prober._probe_ccache(configs)

    -- get the ccache mode
    local mode = configs.ccache

    -- ok? 
    if mode and mode == "y" and configs.__ccache then return true end

    -- disable?
    if mode and mode == "n" then
        configs.__ccache = nil
        return true
    end

    -- probe the ccache path
    local ccache_path = tools.probe("ccache", {"/usr/bin", "/usr/local/bin", "/opt/bin", "/opt/local/bin"})

    -- probe ok? update it
    if ccache_path then
        configs.ccache = "y"
        configs.__ccache = ccache_path
    else
        configs.ccache = "n"
    end

    -- ok
    return true
end

-- probe the project configure 
function prober.config(configs)

    -- probe the architecture
    if not prober._probe_arch(configs) then return end

    -- probe the ccache
    if not prober._probe_ccache(configs) then return end

end

-- probe the global configure 
function prober.global(configs)

    -- probe the ccache
    if not prober._probe_ccache(configs) then return end

end

-- return module: prober
return prober