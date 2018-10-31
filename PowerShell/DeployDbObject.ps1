cls
$servers = "ITSQLSISSTAGING","ITSQLSISPROD","ITVSQLTEST02"

$server = $servers  | Out-GridView -Title "Pick Db Instance" -OutputMode Single  

$db     = "Zangle"
If ($server -eq "ITVSQLTEST02")
{
    $db = "Zangle", "QUpgrade" | Out-GridView -Title "Pick Database" -OutputMode single 
}

Set-Location "C:\SourceGit\SSRS Reporting\Q_SSRS_Reports\Report.Deployment\"

$scriptFiles         = "asd_it_enroll_hist_k12_rpt.sql"               ,
                       "asd_it_official_behavior_hist_rpt.sql"        ,
                       "asd_it_student_immun_rpt.sql"                 ,
                       "asd_it_test_history_rpt_rev2.sql"             ,
                                                                      
                       "onreg.asd_it_registration_record_Q.sql"       ,

                       "asd_it_withdrawal_checklist_rpt_maindata.sql" ,
                       "asd_it_withdrawal_checklist_rpt_lockers.sql"  ,
                       "asd_it_withdrawal_checklist_rpt_standards.sql"


$reportDeployScripts = "EnrollmentAudit_Deployment.sql"     ,                        
                       "BehaviorHistory_Deployment.sql"     ,
                       "EnrollmentHistory_Deployment.sql"   ,
                       "ImmunizationHistory_Deployment.sql" ,
                       "TestHistory_Deployment.sql"         ,
                       "Withdrawal_Checklist_Deployment.sql",
                       "Online_Registration_Submission_Record_Deployment.sql"

Write-Output "'n Database Objects -->'n" 
$scriptFiles | 
    Out-GridView -Title "Pick Report DB Objects" -OutputMode Multiple | 
    ForEach-Object {"Running --> " + $_ ; Invoke-Sqlcmd  -InputFile $_ -ServerInstance $server -Database $db -ErrorAction Stop} 

Write-Output "'n Reports -->'n" 
$reportDeployScripts |
    Out-GridView -Title "Pick Reports to Deploy/Refresh Parameters in Q" -OutputMode Multiple | 
    ForEach-Object {"Running --> " + $_ ; Invoke-Sqlcmd  -InputFile $_ -ServerInstance $server -Database $db -ErrorAction Stop}  
