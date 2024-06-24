mod app;
use colored::{ColoredString, Colorize};
use std::io::stdin;
use std::io::{self, Write};
use std::{env, path::Path};

fn main() {
    println!(
        "[{}] {} {} Started.",
        "✔".green().bold(),
        app::NAME,
        app::VERSION,
    );

    let cwd = env::current_dir().unwrap();
    let full_path = cwd.join("boxwallet");
    let path_exists = Path::new(&full_path).exists();

    println!(
        "[{}] Checking if {} is already installed.",
        bool_to_glyph(path_exists),
        app::BOXWALLET
    );

    if !path_exists {
        let mut value = String::new();
        print!(
            "    {} is not currently installed in: {}\n\nWould you like to install it? (y/n)",
            app::BOXWALLET,
            full_path.to_string_lossy()
        );
        io::stdout().flush().unwrap(); // Add this line to flush the output

        let _ = std::io::stdin().read_line(&mut value).unwrap();
        // value.pop(); // Remove the newline character.
        print!("Value entered: {}", value);
    }

    println!("{} Finished.", app::NAME);
}

fn bool_to_glyph(b: bool) -> ColoredString {
    if b == true {
        return "✔".green().bold();
    } else {
        return "X".red().bold();
    }
}
