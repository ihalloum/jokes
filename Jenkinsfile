pipeline {
    environment {
        devImage = "ghcr.io/ihalloum/jokes-app:dev"
        prodImage= "ghcr.io/ihalloum/jokes-app:latest"
        /* GitHub registry Credential*/
        registryCredential = "ghcr"
    }
    agent any
    stages {

        /* Build development docker image for our project and push it to GitHub registry */
        stage('Build Development Image') {
            when {
                 expression { env.GIT_BRANCH == 'origin/dev' }
            }
             steps {

                script {
                    dockerImage = docker.build devImage
                    docker.withRegistry( 'https://ghcr.io',  registryCredential ) {
                        dockerImage.push()
                    }
                }

             }
        }

        /* Run Unit test on development image */
        stage("Unit Test"){
            when {
                expression { env.GIT_BRANCH == 'origin/dev' }
            }
            steps {
                sh 'docker run --rm --name test -v ${PWD}/tests:/usr/src/app/tests ${devImage} python -m pytest'
             }
         }

        /* Run container from development image at port 5000 for testing */
        stage('Deploy to Development ') {
            when {
                expression { env.GIT_BRANCH == 'origin/dev' }
            }
            steps {
                sh 'docker container rm -f jokes-app-dev'
                sh 'docker run --restart unless-stopped -p 5000:5000 --name jokes-app-dev -d ${devImage}'
            }
        }

        /* After testing and when merge to main build production image from main branch and push it to GitHub registry */
         stage('Build Production Image') {
            when {
                 expression { env.GIT_BRANCH == 'origin/main' }
            }
             steps {
                script {
                    dockerImage = docker.build prodImage
                    docker.withRegistry( 'https://ghcr.io',  registryCredential ) {
                        dockerImage.push()
                    }
                }
             }
        }
        /* Run container from production image at port 80 */
        stage('Deploy to Production ') {
            when {
                expression { env.GIT_BRANCH == 'origin/main' }
            }
             steps {
                sh 'docker container rm -f jokes-app'
                sh 'docker run --restart unless-stopped -p 80:5000 --name jokes-app -d ${prodImage}'
             }
         }
    }
}