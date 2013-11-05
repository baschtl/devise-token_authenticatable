# Helpers used in integration testing.
#

# Shortcut to the warden instance.
#
def warden
  request.env['warden']
end
