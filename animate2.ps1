# Define the box character
$boxChar = "`u{002588}"

# Define the starting position of the box
$x = 0

# Loop indefinitely to animate the box
while ($true) {
  # Clear the screen
  Clear-Host

  # Move the cursor to the starting position of the box
  [Console]::SetCursorPosition($x, 0)

  # Clear the screen
  # Write-Host -NoNewline $whiteSpace

  # Output the box character
  [Console]::SetCursorPosition($x, 0)
  Write-Host -NoNewline $boxChar
  [Console]::SetCursorPosition($x, 1)
  Write-Host -NoNewline $boxChar
  [Console]::SetCursorPosition($x, 2)
  Write-Host -NoNewline $boxChar
  [Console]::SetCursorPosition($x, 3)
  Write-Host -NoNewline $boxChar
  [Console]::SetCursorPosition($x, 4)
  Write-Host -NoNewline $boxChar
  [Console]::SetCursorPosition($x, 5)
  Write-Host -NoNewline $boxChar

  # Update the position of the box
  $x = ($x + 1) % 10

  # Sleep for a short time before updating the screen again
  Start-Sleep -Milliseconds 100
}
