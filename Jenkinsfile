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
				script {
				sh "chmod +x changeTag.sh"
				sh "./changeTag.sh ${DOCKER_TAG}"
				sshagent(['kubernetes_client'])
				{
					sh 'scp -o StrictHostKeyChecking=no node-deployment.yaml ubuntu@54.210.62.62:/home/ubuntu/'
					
					script{
						try{
							sh "ssh ubuntu@54.210.62.62 kubectl apply -f ."
						}catch(error){
							sh "ssh ubuntu@54.210.62.62 kubectl create -f ."	
						}
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
