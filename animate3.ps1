$Label = new-object system.windows.forms.Label
$Label.Font = 'Ariel,12pt'
$Label.Text = ""
$Label.AutoSize = $True
$Label.Location = new-object system.drawing.size(50,10)
$Form.Controls.Add($Label)

$LoadingAnimation = @(".....","0....",".0...","..0..","...0.","....0",".....")
$AnimationCount = 0

$test = start-job -Name Job -ScriptBlock { for($t=1;$t -gt 0; $t++){} }
while ($test.JobStateInfo.State -eq "Running")
{
    $Label.Text = $LoadingAnimation[($AnimationCount)]
    $AnimationCount++
    if ($AnimationCount -eq $LoadingAnimation.Count){$AnimationCount = 0}
    Start-Sleep -Milliseconds 200
}