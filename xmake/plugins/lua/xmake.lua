--!The Make-like Build Utility based on Lua
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
-- Copyright (C) 2015 - 2016, ruki All rights reserved.
--
-- @author      ruki
-- @file        xmake.lua
--

-- define task
task("lua")

    -- set category
    set_category("plugin")

    -- on run
    on_run(function ()
           
        -- imports
        import("core.base.option")

        -- list all scripts?
        if option.get("list") then
            print("scripts:")
            local files = os.match(path.join(os.scriptdir(), "scripts/*.lua"))
            for _, file in ipairs(files) do
                print("    " .. path.basename(file))
            end
            return 
        end

        -- get script name
        local name = option.get("script")
        if not name then
            raise("no script!")
        end

        -- import script
        if os.isfile(name) then
            import(path.basename(name), {rootdir = path.directory(name)}).main(option.get("arguments"))
        else
            import("scripts." .. name).main(option.get("arguments"))
        end
    end)

    -- set menu
    set_menu({
                    -- usage
                    usage = "xmake lua|l [options] [script] [arguments]"

                    -- description
                ,   description = "Run the lua script."

                    -- xmake l
                ,   shortname = 'l'

                    -- options
                ,   options = 
                    {
                        {'l', "list",       "k",  nil,          "List all scripts."             }      
                    ,   {nil, "script",     "v",  nil,          "Run the given lua script."     }      
                    ,   {nil, "arguments",  "vs", nil,          "The script arguments."         }
                    }
                })



