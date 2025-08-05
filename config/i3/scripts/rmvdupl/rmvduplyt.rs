use std::io::{self, BufRead};
use std::fs;
use std::path::Path;

fn yt_clean_text(input: &str) -> String {
    let mut cleaned = input.to_lowercase();
    cleaned.retain(|c| !c.is_whitespace());

    if let Some(start) = cleaned.find('[') {
        if let Some(end) = cleaned.rfind('.') {
            if start < end {
                cleaned.replace_range(start..end, "");
            }
        }
    }

    cleaned
}

fn main() {
    let stdin = io::stdin();

    for line in stdin.lock().lines() {
        if let Ok(original) = line {
            if original.trim().is_empty() {
                continue;
            }

            let cleaned = yt_clean_text(&original);
            let original_path = Path::new(&original);
            let new_path = Path::new(&cleaned);

            if original_path == new_path {
                continue;
            }

            if new_path.exists() {
                if let Err(e) = fs::remove_file(&new_path) {
                    eprintln!("Failed to remove existing '{}': {}", cleaned, e);
                    continue;
                }
            }

            if let Err(e) = fs::rename(&original, &cleaned) {
                eprintln!("Failed to rename '{}': {}", original, e);
            } else {
                println!("Renamed '{}' -> '{}'", original, cleaned);
            }
        }
    }
}
