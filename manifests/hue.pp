# == Class cdh4::hue
#
# Installs hue, sets up the hue.ini file
# and ensures that hue server is running.
# This requires that cdh4::hadoop::config is included.
#
class cdh4::hue(
	$secret_key             = undef,
	$smtp_host              = 'localhost',
	$smtp_port              = 25,
	$smtp_user              = undef,
	$smtp_password          = undef,
	$smtp_from_email        = undef,
	$ldap_url               = undef,
	$ldap_cert              = undef,
	$ldap_nt_domain         = undef,
	$ldap_bind_dn           = undef,
	$ldap_base_dn           = undef,
	$ldap_bind_password     = undef,
	$ldap_username_pattern  = undef,
	$ldap_user_filter       = undef,
	$ldap_user_name_attr    = undef,
	$ldap_group_filter      = undef,
	$ldap_group_name_attr   = undef,
	$ldap_group_member_attr = undef)
{
	include cdh4::hue::install

	# config needs hue installed and hadoop config defined.
	class { "cdh4::hue::config":
		secret_key             => $secret_key,
		smtp_host              => $smtp_host,
		smtp_port              => $smtp_port,
		smtp_user              => $smtp_user,
		smtp_password          => $smtp_password,
		smtp_from_email        => $smtp_from_email,
		ldap_url               => $ldap_url,
		ldap_cert              => $ldap_cert,
		ldap_nt_domain         => $ldap_nt_domain,
		ldap_bind_dn           => $ldap_bind_dn,
		ldap_base_dn           => $ldap_base_dn,
		ldap_bind_password     => $ldap_bind_password,
		ldap_username_pattern  => $ldap_username_pattern,
		ldap_user_filter       => $ldap_user_filter,
		ldap_user_name_attr    => $ldap_user_name_attr,
		ldap_group_filter      => $ldap_group_filter,
		ldap_group_name_attr   => $ldap_group_name_attr,
		ldap_group_member_attr => $ldap_group_member_attr,
		require                => [Class["cdh4::hue::install"], Class["cdh4::hadoop::config"]],
	}


	# The hue service subscribes to the hue config file.
	class { "cdh4::hue::service": 
		require => Class["cdh4::hue::config"],
	}
}
