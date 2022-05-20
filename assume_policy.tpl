{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": ${principals},
      "Effect": "Allow",
      "Sid": "AssumeRole"
    }
  ]
}
