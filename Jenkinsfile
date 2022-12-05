pipeline {
    agent any
    
    stages {

       stage("Build Against Production"){
steps{
         script {
        sh '''
            packer init tomcat8.pkr.hcl
            packer build tomcat8.pkr.hcl
              '''

         }
          }  
        }



        }
post {
 success{
         script {
                 if (env.BRANCH_NAME == 'master') {
                slackSend channel: "#devs", message: "New Tomcat8 Image  ${env.JOB_NAME}"
                    
                } 
        }


}

}

      }
