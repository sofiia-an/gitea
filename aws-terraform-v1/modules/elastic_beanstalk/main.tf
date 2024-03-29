resource "aws_elastic_beanstalk_application" "gitea_app" {
    name = "Gitea-Application"
}

resource "aws_elastic_beanstalk_application_version" "gitea_app_version" {
  name = "latest"
  application = aws_elastic_beanstalk_application.gitea_app.name
  bucket = var.bucket_name
  key = var.bucket_key
}

resource "aws_elastic_beanstalk_environment" "gitea-env" {
    name = "Gitea-Env"
    application = aws_elastic_beanstalk_application.gitea_app.name
    solution_stack_name = "64bit Amazon Linux 2023 v4.2.2 running Docker"
    tier = "WebServer"
    version_label = aws_elastic_beanstalk_application_version.gitea_app_version.name

    setting {
      namespace = "aws:autoscaling:launchconfiguration"
      name = "InstanceType"
      value = var.ec2_instance_type
    }

    setting {
      namespace = "aws:autoscaling:launchconfiguration"
      name = "IamInstanceProfile"
      value = var.instance_profile
    }

    setting {
      namespace = "aws:autoscaling:launchconfiguration"
      name = "SecurityGroups"
      value = var.security_groups
    }

    setting {
      namespace = "aws:rds:dbinstance"
      name = "DBAllocatedStorage"
      value = var.db_allocated_storage
    }

    setting {
      namespace = "aws:rds:dbinstance"
      name = "DBDeletionPolicy"
      value = "Delete"
    }

    setting {
      namespace = "aws:rds:dbinstance"
      name = "DBEngine"
      value = var.db_engine
    }

    setting {
      namespace = "aws:rds:dbinstance"
      name = "DBEngineVersion"
      value = var.db_engine_version
    }

    setting {
      namespace = "aws:rds:dbinstance"
      name = "DBInstanceClass"
      value = var.db_instance_type
    }

    setting {
      namespace = "aws:rds:dbinstance"
      name = "DBName"
      value = var.db_name
    }
    setting {
      namespace = "aws:rds:dbinstance"
      name = "DBPassword"
      value = var.db_password
    }

    setting {
      namespace = "aws:rds:dbinstance"
      name = "DBUser"
      value = var.db_username
    }

    setting {
      namespace = "aws:rds:dbinstance"
      name = "HasCoupledDatabase"
      value = "true"
    }

}