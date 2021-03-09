# Rackspace remediation task automation script:
 
### Pre-requisite

  - Clone the code into your local machine  
     e.g. git clone git@github.com:rackerlabs/remediation.git   

  - Fill the variable.txt file with desired info e.g. AccountId, region and DDI

  - Have list of instance IDs in each account in AccountId.txt e.g. '751440249937.txt'  


      ##### Seperate out AR and ASG instances.
      You can generate the instances with following command  
      ``` aws ec2 describe-instances --region <region> --query 'Reservations[*].Instances[*].InstanceId' --output text >> instance_id.txt ```  
      However it's highly recommended to varify the assumption instance list from the customer. 

  #### This script is modify the include ASG instances to run remediation tasks. If you need to exclude them uncomment following line
  ``` #echo "$AG_OUT" >> non_exist.log

2. Usage of the script  

    sh assumption-tasks.sh   
    ```   e.g sh assumption-tasks.sh 

    Menu Options
    [ ] 1) [MUST RUN First]Pre-requisite - Make assumption ready instance list
    [ ] 2) Create AR Alarms
    [ ] 3) Adding detail monitoring
    [ ] 4) Setting up Tags
    [ ] 5) Setting up Rackspace-Instance-Policy
    [ ] 6) Attached Rackspace roles to EC2 instances
    [ ] 7) Install Cloudwatch  / Configure & Check Status
    [ ] 8) Exit from the program
    [ ] 9) Help
    Select the desired options using their number (again to uncheck, ENTER when done): 
    ```
   - #### Option 1 : Pre-requisite - Make assumption ready instance list
     This will first check each instances in instance_id.txt file then find the SSM installed and Online instance. 
     Report the instances which can't run the remediation.
     Create a file which only contains online instances to run the rest of the remediation work.
     
   - #### Option 2 : Addition AR alarms
     This will add CloudWatch alarms to auto recover instances and the alarm tickets of each instances online. 

   - #### Option 3 : Addition Detail monitoring
     This will enable the Detail monitoring of each instances listed online in the  instance_id.txt file 
   - #### Option 4 : Setting up Tags
     This will setup required Tags in each instances online in the instance_id.txt file  
     Setup RackspaceManaged=True   
     For Backup Tag user will prompt to  type "True/False" select according to customer requirement and for ASG it's False.  
     After the Backup tag deploy EBS snapper per the standard deployment approach. Make sure the tag values match (they are case sensitive)   
     https://github.com/rackerlabs/ebs_snapper  
     Next generation AWS tool for EBS snapshots using LambdaWebsite  
     http://blog.rackspace.com/automate-ebs-snapshots-with-snapper  

   - #### Option 5 : Rackspace-Instance-Policy
     This will create required Policies and instance role in the account to be attached to each instances.  
     After this please select option 5.
   - #### Option 6 : Attached Rackspace roles to EC2 instances
     Created instance role in option 5 will be attached to each instances online in instances that doesn't have instance profile
     Instance that do have instance profiles have to manually add required policies.
    And please follow the command output text to setup role in instance profiles
     e.g. 
     ```diff
     - Actions
      1: Instance doesn't have any role attached.
     The custom Instance policies will list for you to add the Rackspace policies. If you select [y] then it will proceed and setup this.
     If not the program will exist and you can modify the script manually.

    #### TO DO IN THE MANAGEMENT CONSOLE
      Above instance profiles listed need to attach Rackspace-Instance-Policy and  AmazonSSMManagedInstanceCore policy if not exist 
      Goto Management Console >>  IAM and select the above role and attach above mentioned policies in each listed role 

   - #### Option 7 : Setup CloudWatch
     This will first install CloudWatch in all online instances.
     Then configure the instace and start the agent.
     This will also check the status of the CW
     All these work done by the script and no need to use the AWS Console SSM Manager.

   - #### Option  : Exit
     Exit from th program.
   - #### Option 9 : Help
     Cat the Readme.md
 
3. Tips & Troubleshooting.
   If you need to increase the batch size change the below parameter at the top of the assumtion-tasks.sh
   ```
   break_interval=30
   ```
   Basic error handling setup in the script.
   If you need to check for any failure instances please check *remediation.log* file.

 
