import os
import subprocess
import sys
import datetime

# Create output folder
output_folder = "03_fastSTRUCTURE"
os.makedirs(output_folder, exist_ok=True)

# Create log file
log_file = f"faststructure_{datetime.datetime.now().strftime('%Y%m%d_%H%M%S')}.log"

# Read the list
with open('vcf_prefixes.txt', 'r') as f:
    prefixes = [line.strip() for line in f.readlines()]

print(f"Found {len(prefixes)} prefixes to process")
print(f"Log file: {log_file}")

# Process using IPython magic
for prefix in prefixes:
    str_file = f"03_fastSTRUCTURE/{prefix}.str"
    
    # Extract group name from prefix (everything before the first underscore)
    group_name = prefix.split('_')[0]
    popmap_file = f"popmap_{group_name}"
    output_prefix = f"03_fastSTRUCTURE/result_{prefix}"
  
    # Check if str file exists
    if not os.path.exists(str_file):
        print(f"❌ STR file not found: {str_file}")
        continue
    
    # Check if popmap file exists
    if not os.path.exists(popmap_file):
        print(f"❌ Popmap file not found: {popmap_file}")
        continue

    print(f"Processing: {prefix}")
    print(f"🔄 Processing: {prefix}")
    print(f"   - Group: {group_name}")
    print(f"   - STR file: {str_file}")
    print(f"   - Popmap: {popmap_file}")
    print(f"   - Output: {output_prefix}")
    
    # Use IPython magic to run shell command
    !structure_threader run -K 10 -R 10 -i {str_file} -o {output_prefix} -t 16 -fs ~/.local/bin/fastStructure --pop {popmap_file}
    print(f"✅ Completed: {prefix}\n")

print("🎯 All processing completed!")

                "structure_threader", "run", 
                "-K", "10", "-R", "10",
                "-i", str_file, 
                "-o", output_prefix, 
                "-t", "16",
                "-fs", os.path.expanduser("~/.local/bin/fastStructure"),
                "--pop", popmap_file
            ], capture_output=True, text=True, check=True)
            
            # Log success
            msg = f"SUCCESS: {prefix}"
            print(msg)
            log.write(msg + '\n')
            
            # Log any output from the command
            if result.stdout:
                log.write("Command output:\n")
                log.write(result.stdout + '\n')
                
            success_count += 1
            
        except subprocess.CalledProcessError as e:
            msg = f"FAILED: {prefix}"
            print(msg)
            log.write(msg + '\n')
            log.write(f"Error: {e.stderr}\n")
            fail_count += 1
            
        except Exception as e:
            msg = f"UNEXPECTED ERROR: {prefix} - {e}"
            print(msg)
            log.write(msg + '\n')
            fail_count += 1
        
        log.write('\n')  # Empty line between entries
    
    # Write summary
    log.write("\n=== SUMMARY ===\n")
    log.write(f"Successful: {success_count}\n")
    log.write(f"Failed: {fail_count}\n")
    log.write(f"Completed at: {datetime.datetime.now()}\n")

print(f"Processing completed! Check {log_file} for details.")
print(f"Summary: {success_count} successful, {fail_count} failed")