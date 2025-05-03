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
fn foo<'a>(x: &'a str) -> &'a str
```

* `'a` is a **named lifetime**
* Returned ref is guaranteed to live as long as input

#### Lifetime Elision Rules (Rust's defaults):

```rust
fn(x: &T) -> &T     // becomes: fn<'a>(x: &'a T) -> &'a T
fn(&self) -> &T     // implies lifetime tied to &self
```

Rust will **elide** lifetimes if:

1. There's **one input ref**, output gets its lifetime
2. Method with `&self`/`&mut self`, output tied to `self`
3. No elided output if >1 input refs — must be explicit

---

### 📚 **Lifetime Bounds**

```rust
T: 'a          // T must not contain references shorter than 'a
'a: 'b         // 'a outlives 'b
```

Used in:

* Generics (`struct Foo<'a, T: 'a>`)
* Trait bounds (`impl<'a> Trait for &'a T`)

---

### 📈 **Function Lifetimes**

#### Basic:

```rust
fn bar<'a, 'b>(x: &'a str, y: &'b str) -> &'a str
```

You specify which lifetimes belong to each input/output.

#### With Trait Objects:

```rust
Box<dyn Trait + 'a>
```

Trait object valid at least as long as `'a`.

---

### 🔁 **Higher-Ranked Trait Bounds (HRTBs)**

```rust
for<'a> fn(&'a T)
```

Means: works for **all** lifetimes `'a` (not a specific one)

Example use:

```rust
fn call<F>(f: F)
where
    F: for<'a> Fn(&'a str),
```

Enables **lifetime-polymorphic closures**, i.e., functions valid for **any** lifetime.

---

### 🧪 **Non-Lexical Lifetimes (NLL)**

* Stable since Rust 2018
* Allows borrows to end *before* the end of their scope if not used anymore

```rust
let mut x = String::new();
let y = &x;
println!("{}", y); // borrow ends here
x.push('a');       // allowed, since y is no longer used
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
trait Example {
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
fn foo(x: &'static str) { ... }
```

---

### 🧼 **Lifetime Annotations with `impl Trait`**

```rust
fn get_iter<'a>(s: &'a str) -> impl Iterator<Item = char> + 'a
```

You must **tie lifetimes** when returning `impl Trait` to ensure borrow validity.

---

### 🎭 **Lifetime in Structs**

```rust
struct Holder<'a> {
    value: &'a str,
}
```

* The struct cannot outlive the reference inside

---

### 🧪 **Lifetimes in Closures**

```rust
let x = String::new();
let closure = |s: &str| println!("{}", s);
```

Closures can **capture by reference** or **by move** — compiler infers lifetimes based on usage.

---

### 🧱 **Lifetime Inference in Impl Blocks**

```rust
impl<'a> Foo<'a> {
    fn get(&self) -> &str { self.value }
}
```

Often elided, but for multiple lifetimes or complex cases, be explicit.

---

### 🧩 **`'_`: Inferred Lifetime Placeholder**

Used where the compiler will infer the lifetime but it's helpful to be explicit about intent.

```rust
fn get<'_>(x: &'_ str) -> &'_ str { x }
```

Can also be used in impls:

```rust
impl<'_> Trait for MyType<'_> { }
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

