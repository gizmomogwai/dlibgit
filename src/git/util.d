/*
 *             Copyright Andrej Mitrovic 2013.
 *  Distributed under the Boost Software License, Version 1.0.
 *     (See accompanying file LICENSE_1_0.txt or copy at
 *           http://www.boost.org/LICENSE_1_0.txt)
 */
module git.util;

import std.conv;
import std.exception;
import std.string;

import git.c.errors;

import git.exception;

/**
    Call this function when an error code is returned from a git function.
    It will retrieve the last error and throw a GitException.
*/
package void require(bool state, string file = __FILE__, size_t line = __LINE__)
{
    if (state)
        return;

    const(git_error)* gitError = giterr_last();

    enforce(gitError !is null,
        "Error: No Git error thrown, error condition check is likely invalid.");

    const msg = format("Git error (%s):\n%s.", cast(git_error_t)gitError.klass, to!string(gitError.message));

    giterr_clear();
    throw new GitException(msg, file, line);
}

///
unittest
{
    import git.c.oid;
    require(git_oid_fromstr(null, null) == 0);
}
