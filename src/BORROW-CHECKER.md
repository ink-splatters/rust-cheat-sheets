### 🦀 **Rust Borrow Checker** (lang-features' level)
---

### 📌 **Borrowing Basics**

| Syntax            | Meaning                   | Notes                       |
| ----------------- | ------------------------- | --------------------------- |
| `&T`              | Shared (immutable) borrow | Allows read-only access     |
| `&mut T`          | Mutable borrow            | Exclusive read/write access |
| `*ptr`            | Dereference a pointer     | Unsafe for raw pointers     |
| `ref` / `ref mut` | Pattern matching borrow   | E.g., `let Some(ref x)`     |

---

### 🧬 **Lifetimes**

#### Named Lifetimes

```rust
fn foo<'a>(x: &'a str) -> &'a str {
    x
}
```

* `'a` is a **named lifetime**
* Returned ref is guaranteed to live as long as input

#### Lifetime Elision Rules (Rust's defaults):

```rust
// This:
fn example(x: &str) -> &str {
    x
}

// Desugars to:
fn desugared<'a>(x: &'a str) -> &'a str {
    x
}
```

Rust will **elide** lifetimes if:

1. There's **one input ref**, output gets its lifetime
2. Method with `&self`/`&mut self`, output tied to `self`
3. No elided output if >1 input refs — must be explicit

---

### 📚 **Lifetime Bounds**

```rust
fn bounds<'a, T>(x: T) -> T 
where 
    T: 'a 
{
    x
}

// Outlives bound
fn outlives<'a, 'b>(_x: &'a str, _y: &'b str)
where
    'a: 'b,
{
}
```

Used in:

* Generics (`struct Foo<'a, T: 'a>`)
* Trait bounds (`impl<'a> Trait for &'a T`)

---

### 📈 **Function Lifetimes**

#### Basic:

```rust
fn bar<'a, 'b>(x: &'a str, _y: &'b str) -> &'a str {
    x
}
```

You specify which lifetimes belong to each input/output.

#### With Trait Objects:

```rust
trait Trait {}

fn trait_object<'a>(x: Box<dyn Trait + 'a>) -> Box<dyn Trait + 'a> {
    x
}
```

Trait object valid at least as long as `'a`.

---

### 🔁 **Higher-Ranked Trait Bounds (HRTBs)**

```rust
fn call<F>(f: F)
where
    F: for<'a> Fn(&'a str),
{
    f("hello");
}
```

Enables **lifetime-polymorphic closures**, i.e., functions valid for **any** lifetime.

---

### 🧪 **Non-Lexical Lifetimes (NLL)**

* Stable since Rust 2018
* Allows borrows to end *before* the end of their scope if not used anymore

```rust
fn nll_example() {
    let mut x = String::new();
    let y = &x;
    println!("{}", y); // borrow ends here
    x.push('a');       // allowed, since y is no longer used
}
```

---

### 🏷️ **Lifetime Elision in Traits**

```rust
trait Example {
    fn get(&self) -> &str;
}
```

Is implicitly:

```rust
trait ExampleDesugared {
    fn get<'a>(&'a self) -> &'a str;
}
```

---

### ♻️ **Variance (for Lifetimes)**

Variance affects subtyping and lifetime coercion.

| Type          | Variance in lifetime `'a` |
| ------------- | ------------------------- |
| `&'a T`       | **Covariant**             |
| `fn(&'a T)`   | **Contravariant**         |
| `Cell<&'a T>` | **Invariant**             |

Covariant means `'static` can be coerced to shorter, contravariant means reverse, invariant means neither.

---

### 🧩 **Special Lifetime: `'static`**

* Lives for the entire duration of the program
* Used for constants, string literals, or to indicate ownership independence

```rust
fn foo(x: &'static str) {
    println!("{}", x);
}
```

---

### 🧼 **Lifetime Annotations with `impl Trait`**

```rust
fn get_iter<'a>(s: &'a str) -> impl Iterator<Item = char> + 'a {
    s.chars()
}
```

You must **tie lifetimes** when returning `impl Trait` to ensure borrow validity.

---

### 🎭 **Lifetime in Structs**

```rust
struct Holder<'a> {
    value: &'a str,
}

impl<'a> Holder<'a> {
    fn get(&self) -> &str {
        self.value
    }
}
```

* The struct cannot outlive the reference inside

---

### 🧪 **Lifetimes in Closures**

```rust
fn closure_example() {
    let x = String::from("Hello");
    let closure = |s: &str| println!("{} and {}", s, x);
    closure("Hi");
}
```

Closures can **capture by reference** or **by move** — compiler infers lifetimes based on usage.

---

### 🧱 **Lifetime Inference in Impl Blocks**

```rust
struct Foo<'a> {
    value: &'a str,
}

impl<'a> Foo<'a> {
    fn get(&self) -> &str {
        self.value
    }
}
```

Often elided, but for multiple lifetimes or complex cases, be explicit.

---

### 🧩 **`'_`: Inferred Lifetime Placeholder**

Used where the compiler will infer the lifetime but it's helpful to be explicit about intent.

```rust
fn get(x: &'_ str) -> &'_ str {
    x
}
```

Note: `'_` **cannot** be used in named contexts like `impl<'_>` — use explicit `'a`:

```rust
trait Trait {}

struct MyType<'a> {
    data: &'a str,
}

impl<'a> Trait for MyType<'a> {}
```

---

### 🕵️ **Lifetime Errors (Common)**

| Error                             | Fix                               |
| --------------------------------- | --------------------------------- |
| "does not live long enough"       | Annotate lifetimes; return owned  |
| "cannot borrow `x` as mutable"    | Make sure no immutable refs exist |
| "mismatched types with lifetimes" | Align lifetimes across parameters |

---

### 🚦 **Best Practices**

* Prefer owned types (`String`, `Vec`) unless zero-copy matters
* Use `Option<&T>` when conditional borrow needed
* Use lifetime bounds on traits or structs sparingly — prefer cloning or owning
* If lifetimes get complex — step back and check *ownership*
