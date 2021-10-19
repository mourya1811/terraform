//project id
variable "project_id"{
  description = "Service Project ID"
}

//Bucket Name
variable "name"{
  description = "Unique identifier for the bucket name"
}

//Region Name
variable "region"{
  description = "Region Name"
}

//Mandatory Labels
variable "confidentiality"{
  description = "Valid Values are restricted, confidential, internal and public"
}

variable "integrity"{
  description = "Valid Values are: uncontrolled, accurate, trusted and highlytrusted"
}

variable "trustlevel"{
  description = "Valid Values are: low, medium, high and veryhigh"
}

variable "sub_folders"{
  type = list(string)
  default = []
}

//Bucket IAM
variable "bucket_iam"{
  type = map(
  object({
    role = string    // The role type. eg: roles/storage.obectViewer
    members = list(string)  // A list of members to add to the bucket
    })
  )
  description = ""
  default = {}
}

variable "origin"{
  type = list(string)
  description = "Origin for CORS"
}
variable "method"{
  type = list(string)
  description = "Valid methods are: GET, HEAD, PUT, POST, DELETE"
}
variable "response_header"{
  type = list(string)
  description = "Content Types"
}
