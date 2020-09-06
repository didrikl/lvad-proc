Attribute VB_Name = "Module1"
Sub TimeStamp()
Attribute TimeStamp.VB_Description = "Insert timestamps with seconds"
Attribute TimeStamp.VB_ProcData.VB_Invoke_Func = "t\n14"
    Dim dateCol As String
    Dim activeRow As Integer
    
    dateCol = "A"
    
    ActiveCell.Value = Time
    ActiveCell.NumberFormat = "hh:mm:ss"
    
    activeRow = ActiveCell.Row
    Range(dateCol + CStr(activeRow)).Value = Date
    
    ' Try-catch-solution around the wait timer
    On Error GoTo Oops
    StartWaitTimer
    Exit Sub
Oops:
    ' Do nothing if error occured
    
End Sub

Sub TimeStamp_Shortcut2()
Attribute TimeStamp_Shortcut2.VB_ProcData.VB_Invoke_Func = "q\n14"
    
    Dim dateCol As String
    Dim activeRow As Integer
    
    dateCol = "A"
    
    ActiveCell.Value = Time
    ActiveCell.NumberFormat = "hh:mm:ss"
    
    activeRow = ActiveCell.Row
    Range(dateCol + CStr(activeRow)).Value = Date
    
    ' Try-catch-solution around the wait timer
    On Error GoTo Oops
    StartWaitTimer
    Exit Sub
Oops:
    ' Do nothing if error occured
    
End Sub

Sub StartWaitTimer_Shortcut2()
    
    ' Try-catch-solution around the wait timer
    On Error GoTo Oops
    StartWaitTimer
    Exit Sub
Oops:
    ' Do nothing if error occured
    
End Sub

Sub StartWaitTimer()
Attribute StartWaitTimer.VB_ProcData.VB_Invoke_Func = "i\n14"
    
    Dim Path As String
    Dim durationInSec As Integer
    Dim activeRow As Integer
    Dim durationCol As String
    Dim eventCol As String
    Dim eventVal As String
    
    durationCol = "D"
    eventCol = "I"
    
    activeRow = ActiveCell.Row
    durationInSec = Range(durationCol + CStr(activeRow))
    eventVal = Range(eventCol + CStr(activeRow))
    
    On Error GoTo Oops
    
    If durationInSec > 0 Then
        If eventVal = "-" Then
        
            Path = "C:\Program Files (x86)\Hourglass\Hourglass.exe" _
                + " --title ""Row " + CStr(activeRow) + ":      ** MAKE NOTE **                    """ _
                + " --window-title title" _
                + " --prompt-on-exit off" _
                + " --theme note_row" _
                + " --open-saved-timers off" _
                + " --close-when-expired off" _
                + " --sound ""loud beep""" _
                + " 0:" + CStr(durationInSec)
        Else
            Path = "C:\Program Files (x86)\Hourglass\Hourglass.exe" _
                + " --window-title title" _
                + " --title ""Row " + CStr(activeRow) + "                                          """ _
                + " --prompt-on-exit off" _
                + " --theme event_row" _
                + " --open-saved-timers off" _
                + " --close-when-expired off" _
                + " --sound ""loud beep""" _
                + " 0:" + CStr(durationInSec)
            
            If TaskKill("Hourglass.exe") = 0 Then
                               
                Dim flowCol As String
                Dim flow As Double
                flowCol = "V"
                flow = Range(flowCol + CStr(activeRow - 1))
                If flow = 0 Then
                    If MsgBox("Flow est. note on previous row is missing.", vbOKCancel + vbQuestion, "Notes: Missing flow est.") = 2 Then
                        Exit Sub
                    End If
                End If
                Dim powCol As String
                Dim pow As Double
                powCol = "W"
                pow = Range(powCol + CStr(activeRow - 1))
                If pow = 0 Then
                    If MsgBox("Power note on previous row is missing", vbOKCancel + vbQuestion, "Notes: Missing power") = 2 Then
                        Exit Sub
                    End If
                End If
                
            End If
            
        End If
        
        TaskKill ("Hourglass.exe")
        x = Shell(Path, vbNormalFocus)
        
    End If
    Exit Sub
    
Oops:
    ' Backup solution to start a timer and to ensure that time stamps are inserted
    Path = "C:\Program Files (x86)\Hourglass\Hourglass.exe" _
                + " --window-title title" _
                + " --prompt-on-exit off" _
                + " --theme event_row" _
                + " --open-saved-timers off" _
                + " --close-when-expired off" _
                + " --sound ""loud beep"""
    x = Shell(Path, vbNormalFocus)
    
End Sub

Function TaskKill(sTaskName)
    TaskKill = CreateObject("WScript.Shell").Run("taskkill /f /im " & sTaskName, 0, True)
End Function

