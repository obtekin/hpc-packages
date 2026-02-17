help([[
This module loads the Anaconda3 Environment
Version 2025-12.2
]])

whatis("Name: Anaconda3")
whatis("Version: 2025-12-2")
whatis("Category: compiler, runtime support")
whatis("Description: Miniconda3 (Python 3.13.11 for x86_64)")
whatis("URL: https://python.org/")

-- -------------------------------------------------------------------------
-- Paths
-- -------------------------------------------------------------------------
local sharedir  = "/opt/ohpc/pub"
local category  = "compiler"
local package   = "anaconda3"
local version   = "2025-12-2"
local root      = pathJoin(sharedir, category, package, version)

prepend_path("PATH",            pathJoin(root, "bin"))
prepend_path("MANPATH",         pathJoin(root, "share/man"))
prepend_path("INCLUDE",         pathJoin(root, "include"))
prepend_path("LD_LIBRARY_PATH", pathJoin(root, "lib"))
prepend_path("LIBPATH",         pathJoin(root, "lib"))
prepend_path("PYTHONPATH",      pathJoin(root, "lib"))

-- -------------------------------------------------------------------------
-- Graphics and Session Fixes
-- -------------------------------------------------------------------------
-- Unset SESSION_MANAGER to avoid connection errors in headless environments
unsetenv("SESSION_MANAGER")

-- Disable MIT Shared Memory extension for Qt (fixes X11 rendering issues)
setenv("QT_X11_NO_MITSHM", "1")

-- Disable DRI3 to force fallback to DRI2 (fixes common GLX/OpenGL crashes)
setenv("LIBGL_DRI3_DISABLE", "1")

-- -------------------------------------------------------------------------
-- Environment Fixes (XDG_RUNTIME_DIR)
-- -------------------------------------------------------------------------
if (not os.getenv("XDG_RUNTIME_DIR")) then
    local user = os.getenv("USER") or "default"
    local runtime_dir = pathJoin("/tmp", "runtime-" .. user)
    os.execute("mkdir -p " .. runtime_dir .. " && chmod 700 " .. runtime_dir)
    setenv("XDG_RUNTIME_DIR", runtime_dir)
end

-- -------------------------------------------------------------------------
-- Extra initialization
-- -------------------------------------------------------------------------
if (mode() == "load") then
    local homedir = os.getenv("HOME")
    local condarc = pathJoin(homedir, ".conda.rc")
    local conda   = pathJoin(root, "bin/conda")
    local conda_sh = pathJoin(root, "etc/profile.d/conda.sh")

    if (not isFile(condarc)) then
        execute{cmd=conda .. " config --set auto_activate false", modeA={"load"}}
    end

    if (isFile(conda_sh)) then
        execute{cmd=". " .. conda_sh, modeA={"load"}}
    else
        prepend_path("PATH", pathJoin(root, "bin"))
    end
end
