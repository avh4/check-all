module CheckAll (main) where
import System.Process.Typed (runProcess)

main :: IO ()
main = do
  runProcess "cp a.in a.out" >>= print
