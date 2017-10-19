pipeline {
    agent any 

    stages {
        /*-- stage('cleanup') {
            steps {
                // Recursively delete all files and folders in the workspace
                // using the built-in pipeline command
                deleteDir()
            }
        }*/
        stage('Composer install') {
            steps {
                sh 'php composer.phar install --dev --prefer-dist --no-progress'
            }
        }
        stage('PHP Syntax check') {
            steps {
                sh 'bin/parallel-lint src/'
            }
        }
        stage('Test'){
            steps {
                sh 'bin/phpunit -c app/phpunit.xml || exit 0'
                step([
                    $class: 'XUnitBuilder',
                    thresholds: [[$class: 'FailedThreshold', unstableThreshold: '1']],
                    tools: [[$class: 'PHPUnitJunitHudsonTestType', pattern: 'app/build/logs/phpunit.xml']]
                ])
                publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: 'app/build/coverage', reportFiles: 'index.html', reportName: 'Coverage Coverage', reportTitles: ''])
                /* BROKEN  step([$class: 'CloverPublisher', cloverReportDir: 'app/build/coverage', cloverReportFileName: 'app/build/logs/clover.xml']) */
                /* BROKEN step([$class: 'hudson.plugins.crap4j.Crap4JPublisher', reportPattern: 'app/build/logs/crap4j.xml', healthThreshold: '10']) */
            }
        }
        stage('Checkstyle') {
            steps {
                sh 'bin/phpcs --report=checkstyle --report-file=`pwd`/app/build/logs/checkstyle.xml --standard=PSR2 --extensions=php src/ || exit 0'
                checkstyle canComputeNew: false, defaultEncoding: '', healthy: '', pattern: 'app/build/logs/checkstyle.xml', unHealthy: ''
            }
        }
        stage('Lines of Code') {
            steps { sh 'bin/phploc --count-tests --log-csv app/build/logs/phploc.csv --log-xml app/build/logs/phploc.xml src/' }
        }
        stage('Copy paste detection') {
            steps {
                sh 'bin/phpcpd --log-pmd app/build/logs/pmd-cpd.xml src/ || exit 0'
                dry canComputeNew: false, defaultEncoding: '', healthy: '', pattern: 'app/build/logs/pmd-cpd.xml', unHealthy: ''
            }
        }
        /* -- SLOW */
        stage('Mess detection') {
            steps {
                sh 'bin/phpmd src/ xml app/phpmd.xml --reportfile app/build/logs/pmd.xml src/ || exit 0'
                pmd canComputeNew: false, defaultEncoding: '', healthy: '', pattern: 'app/build/logs/pmd.xml', unHealthy: ''
            }
        }
        /* -- SLOW */
        stage('Software metrics') {
            steps { sh 'bin/pdepend --jdepend-xml=app/build/logs/jdepend.xml --jdepend-chart=app/build/pdepend/dependencies.svg --overview-pyramid=app/build/pdepend/overview-pyramid.svg src/'
            }
        }
        stage('Generate documentation') {
            steps { sh 'bin/phpdox -f app/phpdox.xml'
            }
        }
        stage('Generate php metrics') {
            steps {
            sh 'bin/phpmetrics --report-html=app/build/phpmetrics.html --report-xml=app/build/phpmetrics.xml --report-violations=app/build/violations.xml src'
            publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: 'app/build', reportFiles: 'phpmetrics.html', reportName: 'Phpmetrics report', reportTitles: ''])
            }
        }
    }
}
