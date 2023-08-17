pipeline{
	agent any
// 	tools {
//   		maven 'maven-3'
// 	}
	environment {
  		DOCKER_TAG = getVersion()
	}
	stages{
		stage('SCM'){
			steps{
				git credentialsId: 'git_pass', url: 'https://github.com/Djay-ui/project.git'
			}
		}
// 		stage('Maven Build'){
// 			steps{
// 				sh "mvn clean package"
// 			}
// 		}
		stage('Build') {
			steps{
				script{
				sh ' docker build . -t dhananjaytupe748/project_new:${DOCKER_TAG}'
				}
			}
		}

		stage('Scan') {
			steps{
				sh -c "trivy image dhananjaytupe748/project_new:${DOCKER_TAG} > report.txt"
			}
		}

		stage('Email') {
			steps{
				emailext attachmentsPattern: 'report.txt', body: '<p>This an report for the DVWA docker Image</p>', mimeType: 'text/html', recipientProviders: [buildUser(), culprits(), developers(), requestor(), brokenBuildSuspects(), brokenTestsSuspects()], subject: '$PROJECT_NAME - Build # $BUILD_NUMBER - $BUILD_STATUS:', to: 'dhananajaytupe00@gmail.com'
				}
		}

		stage('Login & Push') {
			steps{
				script{
				withCredentials([string(credentialsId: 'dockerhubpass', variable: 'dockerhubpass')]) {
					sh "docker login -u dhananjaytupe748 -p ${dockerhubpass}"
				}
					sh 'docker push dhananjaytupe748/project_new:${DOCKER_TAG}'
				}
			}
		}
			
		
		stage('Deployment'){
			steps{
				sh "chmod +x changeTag.sh"
				sh "./changeTag.sh ${DOCKER_TAG}"
				sshagent(['kubernetes_client'])
				{
					sh 'scp -o StrictHostKeyChecking=no node-deployment.yaml ubuntu@34.239.102.225:/home/ubuntu/'
					sh 'scp -o StrictHostKeyChecking=no pods.yaml ubuntu@34.239.102.225:/home/ubuntu/'
					
					script{
						try{
							sh "ssh ubuntu@34.239.102.225 kubectl apply -f ."
						}catch(error){
							sh "ssh ubuntu@34.239.102.225 kubectl create -f ."	
						}
					}
				}
			}
		}
		
	}
	post {
		always {
			sh 'docker logout'
		}
	}
	}

def getVersion(){
	def hashcommit=sh returnStdout: true, script: 'git rev-parse --short HEAD'
	return hashcommit
}
