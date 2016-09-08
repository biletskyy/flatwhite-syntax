package main
import "fmt"

func intSeq() func() int {
    i := 0
    return func() int {
        i += 1
        return i
    }
}

func main() {

    queue := make(chan string, 2)
    queue <- "one"
    queue <- "two"
    close(queue)

    for elem := range queue {
        fmt.Println(elem)
    }
}

func main() {

    fmt.Println("go" + "lang")
    fmt.Println("1+1 =", 1+1)
    fmt.Println("7.0/3.0 =", 7.0/3.0)
    fmt.Println(true && false)
    fmt.Println(true || false)
    fmt.Println(!true)
}

const s string = "constant"
func main() {
    fmt.Println(s)
    const n = 500000000
    const d = 3e20 / n
    fmt.Println(d)
    fmt.Println(int64(d))
    fmt.Println(math.Sin(n))
}

func main() {
    fmt.Println(person{"Bob", 20})
    fmt.Println(person{name: "Alice", age: 30})
    fmt.Println(person{name: "Fred"})
    fmt.Println(&person{name: "Ann", age: 40})
    s := person{name: "Sean", age: 50}
    fmt.Println(s.name)
    sp := &s
    fmt.Println(sp.age)
    sp.age = 51
    fmt.Println(sp.age)
}

func main() {
    var a string = "initial"
    fmt.Println(a)
    var b, c int = 1, 2
    fmt.Println(b, c)
    var d = true
    fmt.Println(d)
    var e int
    fmt.Println(e)
    f := "short"
    fmt.Println(f)
}

func main() {
    i := 1
    for i <= 3 {
        fmt.Println(i)
        i = i + 1
    }

    for j := 7; j <= 9; j++ {
        fmt.Println(j)
    }
    for {
        fmt.Println("loop")
        break
    }
}

func main() {
    i := 2
    fmt.Print("write ", i, " as ")
    switch i {
    case 1:
        fmt.Println("one")
    case 2:
        fmt.Println("two")
    case 3:
        fmt.Println("three")
    }
    case time.Saturday, time.Sunday:
        fmt.Println("it's the weekend")
    default:
        fmt.Println("it's a weekday")
    }
    t := time.Now()
    switch {
    case t.Hour() < 12:
        fmt.Println("it's before noon")
    default:
        fmt.Println("it's after noon")
    }

    func main() {
        var a [5]int
        fmt.Println("emp:", a)
        a[4] = 100
        fmt.Println("set:", a)
        fmt.Println("get:", a[4])
        fmt.Println("len:", len(a))
        b := [5]int{1, 2, 3, 4, 5}
        fmt.Println("dcl:", b)
        var twoD [2][3]int
        for i := 0; i < 2; i++ {
            for j := 0; j < 3; j++ {
                twoD[i][j] = i + j
            }
        }
        fmt.Println("2d: ", twoD)


package sort_test

import (
    "fmt"
    "sort"
)

type Person struct {
    Name string
    Age  int
}

func (p Person) String() string {
    return fmt.Sprintf("%s: %d", p.Name, p.Age)
}

// ByAge implements sort.Interface for []Person based on
// the Age field.
type ByAge []Person

func (a ByAge) Len() int           { return len(a) }
func (a ByAge) Swap(i, j int)      { a[i], a[j] = a[j], a[i] }
func (a ByAge) Less(i, j int) bool { return a[i].Age < a[j].Age }

func Example() {
    people := []Person{
        {"Bob", 31},
        {"John", 42},
        {"Michael", 17},
        {"Jenny", 26},
    }

    fmt.Println(people)
    sort.Sort(ByAge(people))
    fmt.Println(people)

    // Output:
    // [Bob: 31 John: 42 Michael: 17 Jenny: 26]
    // [Michael: 17 Jenny: 26 Bob: 31 John: 42]
}

func (b ByteSize) String() string {
    switch {
    case b >= YB:
        return fmt.Sprintf("%.2fYB", b/YB)
    case b >= ZB:
        return fmt.Sprintf("%.2fZB", b/ZB)
    case b >= EB:
        return fmt.Sprintf("%.2fEB", b/EB)
    case b >= PB:
        return fmt.Sprintf("%.2fPB", b/PB)
    case b >= TB:
        return fmt.Sprintf("%.2fTB", b/TB)
    case b >= GB:
        return fmt.Sprintf("%.2fGB", b/GB)
    case b >= MB:
        return fmt.Sprintf("%.2fMB", b/MB)
    case b >= KB:
        return fmt.Sprintf("%.2fKB", b/KB)
    }
    return fmt.Sprintf("%.2fB", b)
}

func editHandler(w http.ResponseWriter, r *http.Request) {
    title := r.URL.Path[len("/edit/"):]
    p, err := loadPage(title)
    if err != nil {
        p = &Page{Title: title}
    }
    fmt.Fprintf(w, "<h1>Editing %s</h1>"+
        "<form action=\"/save/%s\" method=\"POST\">"+
        "<textarea name=\"body\">%s</textarea><br>"+
        "<input type=\"submit\" value=\"Save\">"+
        "</form>",
        p.Title, p.Title, p.Body)
}

func (s *FundServer) loop() {
    for command := range s.Commands {

        // command is just an interface{}, but we can check its real type
        switch command.(type) {

        case WithdrawCommand:
            // And then use a "type assertion" to convert it
            withdrawal := command.(WithdrawCommand)
            s.fund.Withdraw(withdrawal.Amount)

        case BalanceCommand:
            getBalance := command.(BalanceCommand)
            balance := s.fund.Balance()
            getBalance.Response <- balance

        default:
            panic(fmt.Sprintf("Unrecognized command: %v", command))
        }
    }
}
