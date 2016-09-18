putTodo :: (Int, String) -> IO ()
putTodo (n, todo) = putStrLn (show n ++ ": " ++ todo)

prompt :: [String] -> IO ()
prompt todos = do
    putStrLn ""
    putStrLn "Current TODO list:"
    mapM_ putTodo (zip [0..] todos)
    command <- getLine
    interpret command todos

interpret :: String -> [String] -> IO ()
interpret ('+':' ':todo) todos = prompt (todo:todos)
interpret ('-':' ':num ) todos =
    case delete (read num) todos of
        Nothing -> do
            putStrLn "No TODO entry matches the given number"
            prompt todos
        Just todos' -> prompt todos'
interpret  "q"           todos = return ()
interpret  command       todos = do
    putStrLn ("Invalid command: `" ++ command ++ "`")
    prompt todos

delete :: Int -> [a] -> Maybe [a]
delete 0 (_:as) = Just as
delete n (a:as) = do
    as' <- delete (n - 1) as
    return (a:as')
delete _  []    = Nothing

main = do
    putStrLn "Commands:"
    putStrLn "+ <String> - Add a TODO entry"
    putStrLn "- <Int>    - Delete the numbered entry"
    putStrLn "q          - Quit"
    prompt []

s :: String
s = "constant"

main = do
    putStrLn s

    let n = 500000000
    let d = 3e20 / n

    print d
    print $ sin n

main = do
    putStrLn $ "haskell " ++ "lang"
    putStrLn $ "1+1 = " ++ show (1+1)
    putStrLn $ "7.0/3.0 = " ++ show (7.0/3.0)

    print $ True && False
    print $ True || False
    print $ not True

import Control.Monad.Cont

main = do
    forM_ [1..3] $ \i -> do
        print i

    forM_ [7..9] $ \j -> do
        print j

    withBreak $ \break ->
        forM_ [1..] $ \_ -> do
            p "loop"
            break ()

    where
    withBreak = (`runContT` return) . callCC
    p = liftIO . putStrLn

    data Person = Person { name :: String
                         , age :: Int
                         } deriving Show

main = do
    print $ Person "Bob" 20
    print $ Person {name = "Alice", age = 30}
    -- print $ Person {name = "Fred"}
    print $ Person {name = "Ann", age = 40}

    let s = Person {name = "Sean", age = 50}
    putStrLn $ name s
    print $ age s

    let s' = s {age = 51}
    print $ age s'


import Network.URI

main = do
    let s = "postgres://user:pass@host.com:5432/path?k=v#f"
    case parseURI s of
        Nothing  -> error "no URI"
        Just uri -> do
            putStrLn $ uriScheme uri
            case uriAuthority uri of
                Nothing   -> error "no Authority"
                Just auth -> do
                    putStrLn $ uriUserInfo auth
                    putStrLn $ uriRegName auth
                    putStrLn $ uriPort auth
            putStrLn $ uriPath uri
            putStrLn $ uriFragment uri
            putStrLn $ uriQuery uri
