<% if @searchbox_data %>
ace.enable_searchbox_autocomplete = function (e) {
    ace.vars.US_STATES = [
<%=raw @searchbox_data.collect{|u| '"'+u.username+'"'}.join(',')%>
    ];
    try {
        e('#nav-search-input') .typeahead({
            source: ace.vars.US_STATES,
            updater: function (a) {
                return e('#nav-search-input') .focus(),
                a
            }
        })
    } catch (a) {
    }
};
<% end %>