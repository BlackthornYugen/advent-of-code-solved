function ProcessingAnimation($scriptBlock) {
    $cursorTop = [Console]::GetCursorPosition().Item2
    
    try {
        [Console]::CursorVisible = $false
        
        $counter = 0
        $frames = @"
                            .
         //                      
        //                      
       | |                      
      {[D]}                     
   [N] [C]                      
   [Z] [M] [P]                  
    1   2   3                   
    📸                            .
         //                      
        //                      
       | |                      
      [[D]]                     
   [N] [C]                      
   [Z] [M] [P]                  
    1   2   3                   
    📸                            .
        //                   
       | |                   
      [[D]]                  
                            .
   [N] [C]                   
   [Z] [M] [P]               
    1   2   3                
    📸                       
       //                    
      | |                    
     [[D]]                   
                            
   [N] [C]                   
   [Z] [M] [P]               
    1   2   3                
    📸                       
      //                     
     | |                     
    [[D]]                    
                            
   [N] [C]                   
   [Z] [M] [P]               
    1   2   3                
📸                           
     //                      
    | |                      
   [[D]]                     
                            
   [N] [C]                   
   [Z] [M] [P]               
    1   2   3                
📸                          
    //                      
   | |                      
  [[D]]                     
                            
   [N] [C]                  
   [Z] [M] [P]              
    1   2   3               
📸                          
     //                     
    //                      
   | |                      
  [[D]]                     
   [N] [C]                  
   [Z] [M] [P]              
    1   2   3               
📸                          
     //                     
    //                      
   | |                      
  {[D]}                     
   [N] [C]                  
   [Z] [M] [P]              
    1   2   3               
📸                          
    //                      
   | |                      
  {   }                     
   [D]                      
   [N] [C]                  
   [Z] [M] [P]              
    1   2   3               
    📸                      
   | |                      
  {   }                     
                            
   [D]                      
   [N] [C]                  
   [Z] [M] [P]              
    1   2   3               
    📸                      
  {   }                     
                            
                            
   [D]                      
   [N] [C]                  
   [Z] [M] [P]              
    1   2   3               
    📸                      
                            
                            
                            
                            
                            
                            
                            
"@.Split("📸")
        $jobName = Start-Job -ScriptBlock $scriptBlock
    
        # Clear-Host
        while ($jobName.JobStateInfo.State -eq "Running") {
            $frame = $frames[$counter % $frames.Length]
            
            # Clear-Host
            [Console]::SetCursorPosition(0, $cursorTop)
            Write-Host "$frame" -NoNewLine
            
            $counter += 1
            Start-Sleep -Milliseconds 425
        }
        
        # Only needed if you use a multiline frames
        Write-Host ($frames[0] -replace '[^\s]', " ") -NoNewLine
    }
    finally {
        # Throw away any keyboard input during animation
        while ($Host.UI.RawUI.KeyAvailable) {
            $host.ui.rawui.readkey("NoEcho,IncludeKeyup") | Out-Null
        }
        [Console]::SetCursorPosition(0, $cursorTop)
        [Console]::CursorVisible = $true
    }
}

#       //
#      //
#     | |
#    {[D]}   
# [N] [C]    
# [Z] [M] [P]
#  1   2   3 

#       //
#      //
#     | |
#    [[D]]   
# [N] [C]    
# [Z] [M] [P]
#  1   2   3 


#      //
#     | |
#    [[D]]   
#
# [N] [C]    
# [Z] [M] [P]
#  1   2   3 

#     //
#    | |
#   [[D]]   
#
# [N] [C]    
# [Z] [M] [P]
#  1   2   3 

#    //
#   | |
#  [[D]]   
#
# [N] [C]    
# [Z] [M] [P]
#  1   2   3 

#   //
#  | |
# [[D]]   
#
# [N] [C]    
# [Z] [M] [P]
#  1   2   3 

#  //
# | |
#[[D]]   
#
# [N] [C]    
# [Z] [M] [P]
#  1   2   3 

#   //
#  //
# | |
#[[D]]   
# [N] [C]    
# [Z] [M] [P]
#  1   2   3 

#   //
#  //
# | |
#{[D]}   
# [N] [C]    
# [Z] [M] [P]
#  1   2   3 

#  //
# | |
#{   }   
# [D] 
# [N] [C]    
# [Z] [M] [P]
#  1   2   3 

# | |
#{   }   
# 
# [D] 
# [N] [C]    
# [Z] [M] [P]
#  1   2   3 

# [D]        
# [N] [C]    
# [Z] [M] [P]
#  1   2   3 

# In the second step, three crates are moved from stack 1 to stack 3. Crates are moved one at a time, so the first crate to be moved (D) ends up below the second and third crates:

#         [Z]
#         [N]
#     [C] [D]
#     [M] [P]
#  1   2   3

# Then, both crates are moved from stack 2 to stack 1. Again, because crates are moved one at a time, crate C ends up below crate M:

#         [Z]
#         [N]
# [M]     [D]
# [C]     [P]
#  1   2   3

# Finally, one crate is moved from stack 1 to stack 2:

#         [Z]
#         [N]
#         [D]
# [C] [M] [P]
#  1   2   3


ProcessingAnimation { Start-Sleep 5 }