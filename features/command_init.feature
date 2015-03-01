Feature: init command

  Background:
    Given a mocked home directory

  Scenario: init -s should contain status shortcuts
    When I successfully run `scmpuff init -s`
    Then the output should contain "scmpuff_status_shortcuts()"

  Scenario Outline: --aliases controls short aliases in output (default: yes)
    When I successfully run `scmpuff init <flags>`
    Then the output <should?> contain "alias gs='scmpuff_status_shortcuts'"
    And  the output <should?> contain "alias ga='git add'"
    Examples:
      | flags              | should?    |
      | -s                 | should     |
      | -as                | should     |
      | -a -s              | should     |
      | -s --aliases=true  | should     |
      | -s --aliases=false | should not |

  Scenario Outline: --wrap controls git cmd wrapping in output (default: yes)
    When I successfully run `scmpuff init <flags>`
    Then the output <should?> contain "function git()"
    Examples:
      | flags              | should?    |
      | -s                 | should     |
      | -ws                | should     |
      | -w -s              | should     |
      | -s --wrap=true     | should     |
      | -s --wrap=false    | should not |

  Scenario Outline: Evaling init -s defines status shortcuts in environment
    When I run `<shell>` interactively
      And I type `eval "$(scmpuff init -s)"`
      And I type "type scmpuff_status_shortcuts"
      And I type "type scmpuff_clear_vars"
      And I type "exit"
    Then the output should not contain "not found"
    Examples:
      | shell |
      | bash  |
      | zsh   |
