pipeline {
	// agent any
	//agent { label 'jenkins-agent' }
	agent { dockerfile true }

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
		
		stage('UI Automation - Chrome') {
			steps {		
				sh 'docker-compose run -e BROWSER="chrome" selenium-test'
			}
		}
		
		stage('UI Automation - Firefox') {
			steps {
				sh 'docker-compose run -e BROWSER="firefox" selenium-test'
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
}










