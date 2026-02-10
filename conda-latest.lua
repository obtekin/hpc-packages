help([[
This module loads the Miniconda3 Environment

See the man pages for python for detailed information
on available compiler options and command-line syntax.

Version 25.7.0
]])

whatis("Name: Miniconda3")
whatis("Version: 25.7.0")
whatis("Category: compiler, runtime support")
whatis("Description: Miniconda3 (Python 3.12.10 for x86_64)")
whatis("URL: https://python.org/")

-- -------------------------------------------------------------------------
-- Paths
-- -------------------------------------------------------------------------
local sharedir  = "/opt/ohpc/pub"
local category  = "compiler"
local package   = "conda3"
local version   = "latest"
local root      = pathJoin(sharedir, category, package, version)

prepend_path("PATH",            pathJoin(root, "bin"))
prepend_path("MANPATH",         pathJoin(root, "share/man"))
prepend_path("INCLUDE",         pathJoin(root, "include"))
prepend_path("LD_LIBRARY_PATH", pathJoin(root, "lib"))
prepend_path("LIBPATH",         pathJoin(root, "lib"))
prepend_path("PYTHONPATH",      pathJoin(root, "lib"))

-- -------------------------------------------------------------------------
-- Extra initialization similar to bash logic
-- -------------------------------------------------------------------------
if (mode() == "load") then
    local homedir = os.getenv("HOME")
    local condarc = pathJoin(homedir, ".conda.rc")
    local conda   = pathJoin(root, "bin/conda")
    local conda_sh = pathJoin(root, "etc/profile.d/conda.sh")

    -- Disable auto_activate if ~/.conda.rc is missing
    if (not isFile(condarc)) then
        execute{cmd=conda .. " config --set auto_activate false", modeA={"load"}}
    end

    -- Initialize conda environment properly
    if (isFile(conda_sh)) then
        -- Source conda.sh into the user shell
        execute{cmd=". " .. conda_sh, modeA={"load"}}
    else
        prepend_path("PATH", pathJoin(root, "bin"))
    end
end
