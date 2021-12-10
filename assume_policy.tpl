{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": ${principalsRole},
      "Effect": "Allow",
      "Sid": ""
    },
    {
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Principal": ${principalsRole},
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
