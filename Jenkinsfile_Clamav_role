pipeline {
    agent any

    stages {
        stage('Cloning Git') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'jenkins', url: 'https://github.com/alehhillka/clamav_role.git']]])
            }
        }

        stage('Deploy to EC2') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'aws-ec2-credentials', keyFileVariable: 'SSH_KEY', passphraseVariable: '', usernameVariable: 'ec2-user')]) {
                    sh '''
                         export ANSIBLE_HOST_KEY_CHECKING=False
                        ansible-playbook playbook.yml -i aws_ec2.yml --private-key /var/lib/jenkins/.ssh/ssh.pem --user ec2-user
                    '''
                }
            }
        }
    }
}
