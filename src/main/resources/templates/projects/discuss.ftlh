<#import "/spring.ftl" as spring />
<#import "*/utils/hangar.ftlh" as hangar />

@*
Discussion page within Project overview.
*@
@import controllers.sugar.Requests.OreRequest
@import models.viewhelper.{ProjectData, ScopedProjectData}
@import ore.OreConfig
@import ore.markdown.MarkdownRenderer
@import views.html.helper.CSPNonce
@import views.html.utils

@(p: ProjectData, sp: ScopedProjectData)(implicit messages: Messages, request: OreRequest[_],
        flash: Flash, config: OreConfig, renderer: MarkdownRenderer, assetsFinder: AssetsFinder)

<#assign scriptsVar>
    <script @CSPNonce.attr>
        DiscourseEmbed = {
            discourseUrl: '${config.app.discourseUrl}/',
            topicId: ${p.project.topicId}
        };
    </script>
    <script type="text/javascript" src="<@hangar.url "javascripts/projectDiscuss.js" />"></script>
    <script @CSPNonce.attr>$(function() { $('.btn-edit').click(); });</script>
</#assign>

@projects.view(p, sp, "#discussion", additionalScripts = scripts) {

    <div id='discourse-comments'></div>
    <div class="row">
    <#if request.headerData.currentUser??>
        <div class="col-md-8">
            <div class="reply-box">
                <#if sp.canPostAsOwnerOrga>
                <div class="pull-right push-down">
                    <i class="minor"><@spring.message "project.discuss.postAs" /></i>
                    <select name="poster" form="form-editor-save">
                        <option selected>${request.headerData.currentUser.name}</option>
                        <option>${p.projectOwner.name}</option>
                    </select>
                </div>
                        <div class="clearfix"></div>
                </#if>

                <div class="push-down">
                    @utils.editor(
                    saveCall = routes.getRouteUrl("projects.postDiscussionReply", p.project.ownerName, p.project.slug),
                    cancellable = false,
                    enabled = true
                    )
                </div>
            </div>
            <div class="reply-controls">
                <a class="forums" target="_blank" rel="noopener"
                href="${config.app.discourseUrl}/t/${p.project.topicId}">
                <@spring.message "general.viewOnForums" />
                </a>
            </div>
        </div>
    <#else>
        <div class="pull-right">
            <a href="${routes.getRouteUrl("users.login", "", "", request.path)}"><@spring.message "general.login" /></a>
            <span class="minor"> <@spring.message "general.toReply" /></span>
        </div>
    </#if>
    </div>

}
