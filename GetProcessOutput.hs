module GetProcessOutput (getProcessOutput) where

import System.IO
  ( hGetContents )
import System.Process
  ( runInteractiveCommand
  , waitForProcess
  )
import System.Exit
  ( ExitCode ( .. ) )

{-
  A small function for blindly running a process until it completes
  its output and then waiting for its exit code.
  We return both the output (excluding stderr) plus the exit code.
  
  Taken from https://mail.haskell.org/pipermail/haskell-cafe/2007-November/035146.html
-}
getProcessOutput :: String -> IO (String, ExitCode)
getProcessOutput command =
     -- Create the process
  do (_pIn, pOut, pErr, handle) <- runInteractiveCommand command
     -- Wait for the process to finish and store its exit code
     exitCode <- waitForProcess handle
     -- Get the standard output.
     output   <- hGetContents pOut
     -- return both the output and the exit code.
     return (output, exitCode)


