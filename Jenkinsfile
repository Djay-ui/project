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
				sh 'docker build . -t dhananjaytupe748/project_new:${DOCKER_TAG}'
				}
			}
		}

		stage('Login & Push') {
			steps{
				withCredentials([string(credentialsId: 'dockerhubpwd', variable: 'DockerHubpwd')]) {
					sh "docker login -u dhananjaytupe748 -p ${DockerHubpwd}"
				}
					sh 'docker push dhananjaytupe748/project_new:${DOCKER_TAG}'
			}
		}
		
		stage('Deployment'){
			steps{
				sh "chmod +x changeTag.sh"
				sh "./changeTag.sh ${DOCKER_TAG}"
				sshagent(['kubernetes_client'])
				{
					sh 'scp -o StrictHostKeyChecking=no node-deployment.yaml ubuntu@3.94.145.205:/home/ubuntu/'
					
					script{
						try{
							sh "ssh ubuntu@3.94.145.205 kubectl apply -f ."
						}catch(error){
							sh "ssh ubuntu@3.94.145.205 kubectl create -f ."	
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
