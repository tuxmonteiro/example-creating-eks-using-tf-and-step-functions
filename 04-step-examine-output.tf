locals {
  step-examine-output = {
    "Examine output" = {
      "Type" = "Choice"
      "Choices" = [{
        "And" = [{
          "Variable"           = "$.RunJobResult.logs[0]"
          "NumericGreaterThan" = 3.141
          },
          {
            "Variable"        = "$.RunJobResult.logs[0]"
            "NumericLessThan" = 3.142
        }]
        "Next" = "Send expected result"
      }]
      "Default" = "Send unexpected result"
    }
  }
}
