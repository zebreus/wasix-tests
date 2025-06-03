use std::env;
use std::ffi::OsString;
use std::process::Command;

fn main() {
    let prog = env::args().next().unwrap_or_default();
    let is_cpp = prog.ends_with("++");
    let native_compiler = if is_cpp {
        "/home/lennart/Documents/llvm-project/builddebug/bin/clang++"
    } else {
        "/home/lennart/Documents/llvm-project/builddebug/bin/clang"
    };

    let wasix_sysroot = match env::var("WASIX_SYSROOT") {
        Ok(v) => v,
        Err(_) => {
            eprintln!("WASIX_SYSROOT environment variable not set");
            std::process::exit(1);
        }
    };

    let passed_args: Vec<OsString> = env::args_os().skip(1).collect();

    let mut run_linker = true;
    let mut shared_library = false;
    for arg in &passed_args {
        if let Some(s) = arg.to_str() {
            match s {
                "-c" | "-S" | "-E" => run_linker = false,
                "-shared" | "--shared" => shared_library = true,
                _ => {}
            }
        }
    }

    let mut args: Vec<OsString> = Vec::new();
    args.push("--target=wasm32-wasi".into());
    args.push(format!("--sysroot={}", wasix_sysroot).into());
    args.extend(["-matomics","-mbulk-memory","-mmutable-globals"].iter().map(|&s| OsString::from(s)));
    args.push("-pthread".into());
    args.extend(["-mthread-model","posix"].iter().map(|&s| OsString::from(s)));
    args.push("-ftls-model=global-dynamic".into());
    args.push("-fno-trapping-math".into());
    args.extend(["-D_WASI_EMULATED_MMAN","-D_WASI_EMULATED_SIGNAL","-D_WASI_EMULATED_PROCESS_CLOCKS"].iter().map(|&s| OsString::from(s)));
    args.push("-fvisibility=default".into());
    args.push("-fwasm-exceptions".into());
    args.push("-fPIC".into());
    args.extend(["--start-no-unused-arguments","-mllvm","--wasm-enable-sjlj","--end-no-unused-arguments"].iter().map(|&s| OsString::from(s)));

    if run_linker {
        args.extend([
            "-Wl,--experimental-pic",
            "-Wl,--extra-features=atomics,--extra-features=bulk-memory,--extra-features=mutable-globals",
            "-Wl,--shared-memory",
            "-Wl,--export-if-defined=__wasm_apply_data_relocs",
            "-Wl,--export-if-defined=__cxa_thread_atexit_impl",
            "-Wl,--export=__wasm_call_ctors",
            "-Wl,-mllvm,--wasm-enable-sjlj",
        ].iter().map(|&s| OsString::from(s)));

        if shared_library {
            args.extend([
                "--no-standard-libraries",
                "-nostdlib++",
                "-Wl,--no-entry",
                "--shared",
                "-Wl,--unresolved-symbols=import-dynamic",
                &format!("{}/lib/wasm32-wasi/scrt1.o", wasix_sysroot),
            ].iter().map(|s| OsString::from(s)));
        } else {
            args.extend([
                "-Wl,--import-memory",
                "-Wl,-pie",
                "-Wl,--export-all",
                "-Wl,--whole-archive,-lc,-lutil,-lresolv,-lrt,-lm,-lpthread,-lc++,-lc++abi,-lwasi-emulated-mman,-lwasi-emulated-getpid,-lcommon-tag-stubs,--no-whole-archive",
            ].iter().map(|&s| OsString::from(s)));
        }
    }

    args.extend(passed_args.iter().cloned());

    if !run_linker {
        print_cmd(native_compiler, &args);
        let status = Command::new(native_compiler).args(&args).status().expect("failed to run compiler");
        std::process::exit(status.code().unwrap_or(1));
    }

    let status = Command::new(native_compiler).args(&args).status().expect("failed to run compiler");
    if !status.success() {
        std::process::exit(status.code().unwrap_or(1));
    }

    let mut output_file = OsString::from("a.out");
    let mut iter = args.iter();
    while let Some(arg) = iter.next() {
        if arg == "-o" {
            if let Some(v) = iter.next() {
                output_file = v.clone();
                break;
            }
        } else if let Some(s) = arg.to_str() {
            if s.starts_with("-o") && s.len() > 2 {
                output_file = OsString::from(&s[2..]);
                break;
            }
        }
    }

    Command::new("wasm-opt")
        .arg("--experimental-new-eh")
        .arg(&output_file)
        .arg("-o")
        .arg(&output_file)
        .status()
        .expect("failed to run wasm-opt");
}

fn print_cmd(cmd: &str, args: &[OsString]) {
    let mut out = String::from(cmd);
    for a in args {
        out.push(' ');
        out.push_str(a.to_string_lossy().as_ref());
    }
    println!("{}", out);
}
