I18n::Backend::Simple.send(:include, I18n::Backend::Pluralization)

{
  :ru => {
    :i18n => {
      :plural => {
        :rule => lambda { |n|
          case
            when n % 10 == 1 && n % 100 != 11
              :one
            when (2..4) === n % 10 && ! (12..14) === n % 100
              :few
            when n % 10 == 0 || (5..9) === n % 10 || (11..14) === n % 100
              :many
            else
              :other
          end
        }
      }
    }
  }
}
