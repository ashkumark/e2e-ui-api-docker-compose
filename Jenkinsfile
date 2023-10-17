pipeline {
	 agent any
	//agent { label 'jenkins-agent' }
	//agent { dockerfile true }

	environment {
		dockerImage = ''
	}
	
	stages {
		stage('Checkout code') {
			steps {
				checkout scm
			}
		}
		
		stage('Build Image') {
	       steps {
	           script {
	               dockerImage = docker.build("docker-e2e-automation")
	           }
	       }
	    }
	    
		// Start docker-compose selenium-hub
		stage('Start docker-compose') {
			steps {
				sh 'docker-compose up -d'
			}
		}

        stage('API Automation') {
            steps {
                sh 'docker-compose run -e TYPE="@API" api-test-service'
            }
        }

		stage('UI Automation - Chrome') {
			steps {		
				sh 'docker-compose run -e TYPE="@UI" -e BROWSER="chrome" ui-test-service'
			}
		}
		
		stage('UI Automation - Firefox') {
			steps {
				sh 'docker-compose run -e TYPE="@UI" -e BROWSER="firefox" ui-test-service'
			}
		}
		
		stage('Docker Teardown') {
			steps {
				/* Tear down docker compose */
				sh 'docker-compose down'
				
                /* Tear down all containers */
                sh 'docker-compose rm -sf'
			}
		}
	}

	post {
            always {
                cleanWs()
            }
    }
}










