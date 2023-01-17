<#import "template.ftl" as layout>
<@layout.registrationLayout displayInfo=social.displayInfo displayWide=(realm.password && social.providers??); section>
    <#if section = "header">
        ${msg("doLogIn")}
    <#elseif section = "form">
        <div id="kc-form" class="${properties.kcContentWrapperClass!}">
            <ul class="${properties.kcFormSocialAccountListClass!} <#if social.providers?size gt 4>${properties.kcFormSocialAccountDoubleListClass!}</#if>">
                <#list social.providers as p>
                    <li class="${properties.kcFormSocialAccountListLinkClass!}"><a href="${p.loginUrl}" id="zocial-${p.alias}" class="zocial ${p.providerId}" onclick="setSelectedIdp('${p.alias}');"> <span>${p.displayName}</span></a></li>
                </#list>
            </ul>
        </div>
            <div id="kc-idpRemember" style="text-align: center">
                <input id="kc-idpRememberChoice" type="checkbox" name="kc-idpRememberChoice">
                    <label>Remember my choice *</label> 
                </input>
                <p id="kc-idpRememberHint" style="margin-top: 50px; text-align: justify;">* If you want to return this page, remove the corresponding cookie in your browser</p>
            </div>
    </#if>

</@layout.registrationLayout>
