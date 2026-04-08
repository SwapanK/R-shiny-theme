# Page_Gallery_UI.R
galleryUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    # Add custom CSS for gallery cards (consistent with app theme)
    tags$head(
      tags$style(HTML("
        /* Gallery Grid */
        .gallery-grid {
          display: grid;
          grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
          gap: 25px;
          padding: 20px 0;
        }
        
        /* Base Card Style */
        .gallery-card {
          background: white;
          border-radius: 12px;
          padding: 24px;
          box-shadow: 0 4px 12px rgba(0,0,0,0.05);
          border: 1px solid #e0e0e0;
          transition: all 0.2s ease;
          display: flex;
          flex-direction: column;
          min-height: 320px;
          position: relative;
        }
        
        .gallery-card:hover {
          box-shadow: 0 6px 16px rgba(0,0,0,0.1);
          transform: translateY(-2px);
        }
        
        /* Card colors based on category - Using blue theme */
        .gallery-card.pinned-card {
          background: linear-gradient(135deg, #e8f0fe 0%, #bbdefb 100%);
          border-left: 5px solid #1a73e8;
          border-bottom: 3px solid #0d47a1;
        }
        
        .gallery-card.reminder-card {
          background: linear-gradient(135deg, #ffd6d6 0%, #ffb3b3 100%);
          border-left: 5px solid #dc3545;
          border-bottom: 3px solid #c82333;
        }
        
        .gallery-card.ai-card {
          background: linear-gradient(135deg, #d4f0f0 0%, #b0e0e6 100%);
          border-left: 5px solid #17a2b8;
          border-bottom: 3px solid #117a8b;
        }
        
        .gallery-card.general-card {
          background: linear-gradient(135deg, #e2d9ff 0%, #c5b3ff 100%);
          border-left: 5px solid #6f42c1;
          border-bottom: 3px solid #5936a0;
        }
        
        /* Card Header */
        .gallery-card-header {
          display: flex;
          justify-content: space-between;
          align-items: center;
          margin-bottom: 15px;
          padding-bottom: 10px;
          border-bottom: 1px dashed rgba(0,0,0,0.1);
        }
        
        .card-type-badge {
          font-size: 0.9rem;
          font-weight: 700;
          padding: 6px 16px;
          border-radius: 20px;
          background: rgba(255,255,255,0.8);
          color: #202124;
          text-transform: uppercase;
          letter-spacing: 0.5px;
          box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        
        .card-date {
          font-size: 0.9rem;
          color: #666;
          font-weight: 600;
          background: rgba(255,255,255,0.6);
          padding: 5px 14px;
          border-radius: 15px;
        }
        
        /* Card Title */
        .gallery-card-title {
          margin: 0 0 15px 0;
          font-weight: 700;
          color: #000000;
          font-size: 1.3rem;
          line-height: 1.4;
        }
        
        /* Card Content - BIGGER TEXT */
        .gallery-card-content {
          flex: 1;
          font-size: 1.2rem;
          line-height: 1.7;
          color: #202124;
          margin-bottom: 20px;
          padding: 8px 5px;
          white-space: pre-wrap;
          word-wrap: break-word;
          max-height: 200px;
          overflow-y: auto;
          font-family: inherit;
          font-weight: 400;
        }
        
        /* Custom scrollbar */
        .gallery-card-content::-webkit-scrollbar {
          width: 4px;
        }
        
        .gallery-card-content::-webkit-scrollbar-track {
          background: #f1f1f1;
          border-radius: 4px;
        }
        
        .gallery-card-content::-webkit-scrollbar-thumb {
          background: #ccc;
          border-radius: 4px;
        }
        
        /* Card Footer */
        .gallery-card-footer {
          display: flex;
          justify-content: flex-end;
          align-items: center;
          gap: 12px;
          margin-top: auto;
          padding-top: 15px;
          border-top: 1px dashed rgba(0,0,0,0.1);
        }
        
        /* Copy Button - Matching Data Management */
        .gallery-copy-btn {
          background: linear-gradient(135deg, #1a73e8 0%, #0d47a1 100%);
          border: none;
          border-radius: 6px;
          padding: 10px 24px;
          font-size: 1rem;
          font-weight: 500;
          color: white;
          cursor: pointer;
          transition: all 0.2s ease;
          display: inline-flex;
          align-items: center;
          gap: 8px;
          box-shadow: 0 4px 15px rgba(26,115,232,0.3);
        }
        
        .gallery-copy-btn:hover {
          transform: translateY(-2px);
          box-shadow: 0 6px 20px rgba(26,115,232,0.4);
          background: linear-gradient(135deg, #1565c0 0%, #0a2e6e 100%);
          color: white;
        }
        
        /* Delete Button */
        .gallery-delete-btn {
          background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
          border: none;
          color: white;
          font-size: 1rem;
          cursor: pointer;
          padding: 10px 16px;
          border-radius: 6px;
          transition: all 0.2s ease;
          width: auto;
          height: auto;
          display: flex;
          align-items: center;
          gap: 8px;
          box-shadow: 0 4px 15px rgba(220,53,69,0.3);
        }
        
        .gallery-delete-btn:hover {
          transform: translateY(-2px);
          box-shadow: 0 6px 20px rgba(220,53,69,0.4);
          background: linear-gradient(135deg, #c82333 0%, #a71d2a 100%);
          color: white;
        }
        
        /* Add Note Section */
        .gallery-add-section {
          background: white;
          border-radius: 12px;
          padding: 25px;
          margin-bottom: 30px;
          box-shadow: 0 4px 12px rgba(0,0,0,0.05);
          border: 1px solid #e0e0e0;
        }
        
        .gallery-header {
          display: flex;
          align-items: center;
          gap: 12px;
          margin-bottom: 25px;
          border-bottom: 3px solid #1a73e8;
          padding-bottom: 15px;
        }
        
        .gallery-header i {
          color: #1a73e8;
          font-size: 2rem;
        }
        
        .gallery-header h3 {
          color: #000000;
          margin: 0;
          font-weight: 700;
          font-size: 1.8rem;
        }
        
        .sub-header {
          display: flex;
          align-items: center;
          gap: 10px;
          margin: 30px 0 20px 0;
        }
        
        .sub-header i {
          color: #1a73e8;
          font-size: 1.5rem;
        }
        
        .sub-header h4 {
          color: #000000;
          margin: 0;
          font-weight: 700;
          font-size: 1.3rem;
        }
        
        /* Form labels - BIGGER */
        .control-label {
          font-weight: 700;
          color: #000000;
          font-size: 1.1rem;
          margin-bottom: 8px;
        }
        
        .form-control, .form-control:focus {
          border: 1px solid #e0e0e0;
          border-radius: 8px;
          padding: 12px 15px;
          transition: all 0.2s ease;
          box-shadow: none;
          font-size: 1rem;
          height: auto;
        }
        
        .form-control:focus {
          border-color: #1a73e8;
          box-shadow: 0 0 0 3px rgba(26,115,232,0.1);
        }
        
        select.form-control {
          padding: 12px 15px;
          font-size: 1rem;
        }
        
        textarea.form-control {
          font-size: 1rem;
          padding: 12px 15px;
        }
        
        /* UNIFORM BUTTON STYLES - Matching Data Management */
        .btn-action {
          background: linear-gradient(135deg, #1a73e8 0%, #0d47a1 100%);
          color: white;
          border: none;
          padding: 12px 20px;
          border-radius: 6px;
          font-weight: 500;
          font-size: 1rem;
          transition: all 0.2s ease;
          box-shadow: 0 4px 15px rgba(26,115,232,0.3);
          display: inline-flex;
          align-items: center;
          gap: 8px;
          justify-content: center;
          width: 100%;
          cursor: pointer;
        }
        
        .btn-action:hover {
          transform: translateY(-2px);
          box-shadow: 0 6px 20px rgba(26,115,232,0.4);
          background: linear-gradient(135deg, #1565c0 0%, #0a2e6e 100%);
          color: white;
        }
        
        .btn-action:disabled {
          opacity: 0.6;
          cursor: not-allowed;
          transform: none;
        }
        
        .btn-secondary-action {
          background: linear-gradient(135deg, #6c757d 0%, #5a6268 100%);
          color: white;
          border: none;
          padding: 12px 20px;
          border-radius: 6px;
          font-weight: 500;
          font-size: 1rem;
          transition: all 0.2s ease;
          box-shadow: 0 4px 15px rgba(108,117,125,0.3);
          display: inline-flex;
          align-items: center;
          gap: 8px;
          justify-content: center;
          width: 100%;
          cursor: pointer;
        }
        
        .btn-secondary-action:hover {
          transform: translateY(-2px);
          box-shadow: 0 6px 20px rgba(108,117,125,0.4);
          background: linear-gradient(135deg, #5a6268 0%, #494f54 100%);
          color: white;
        }
        
        /* Date input specific */
        .input-group.date .form-control {
          padding: 12px 15px;
          font-size: 1rem;
        }
        
        /* Placeholder text */
        ::placeholder {
          color: #999;
          font-size: 0.95rem;
        }
        
        /* Empty State */
        .gallery-empty {
          text-align: center;
          padding: 80px 20px;
          background: #f8f9fa;
          border-radius: 16px;
          margin: 20px 0;
          border: 1px solid #e0e0e0;
        }
        
        .gallery-empty i {
          font-size: 5rem;
          color: #1a73e8;
          margin-bottom: 25px;
        }
        
        .gallery-empty h4 {
          color: #000000;
          font-weight: 700;
          font-size: 1.5rem;
          margin-bottom: 12px;
        }
        
        .gallery-empty p {
          color: #666;
          font-size: 1.1rem;
        }
        
        /* Modern Toast Notification */
        .modern-toast {
          position: fixed;
          bottom: 30px;
          right: 30px;
          background: white;
          color: #1a202c;
          padding: 16px 32px;
          border-radius: 60px;
          font-weight: 600;
          font-size: 1rem;
          box-shadow: 0 20px 40px rgba(0,0,0,0.15);
          z-index: 9999;
          display: flex;
          align-items: center;
          gap: 12px;
          animation: toastSlide 0.3s ease;
        }
        
        .modern-toast.success {
          background: linear-gradient(135deg, #84fab0 0%, #8fd3f4 100%);
          color: #1a4731;
        }
        
        .modern-toast.warning {
          background: linear-gradient(135deg, #fad0c4 0%, #ffd1ff 100%);
          color: #744210;
        }
        
        .modern-toast.error {
          background: linear-gradient(135deg, #fbc2c2 0%, #fda5a5 100%);
          color: #742a2a;
        }
        
        @keyframes toastSlide {
          from { transform: translateX(100%) scale(0.8); opacity: 0; }
          to { transform: translateX(0) scale(1); opacity: 1; }
        }
        
        /* Section header for Your Notes */
        .notes-header {
          display: flex;
          align-items: center;
          gap: 10px;
          margin: 40px 0 20px 0;
          border-bottom: 2px solid #1a73e8;
          padding-bottom: 12px;
        }
        
        .notes-header i {
          color: #1a73e8;
          font-size: 1.5rem;
        }
        
        .notes-header h4 {
          color: #000000;
          margin: 0;
          font-weight: 700;
          font-size: 1.3rem;
        }
        
        /* Form row spacing */
        .form-group {
          margin-bottom: 20px;
        }
        
        /* Button container - matching Data Management */
        .button-container {
          display: flex;
          gap: 15px;
          margin-top: 25px;
          justify-content: flex-end;
        }
      "))
    ),
    
    div(class = "page-container",
        div(class = "content-card",
            # Gallery Header
            div(class = "gallery-header",
                icon("sticky-note"),
                h3("Gallery")
            ),
            
            # Add Note Section
            div(class = "gallery-add-section",
                # Sub-header for Create New Note
                div(class = "sub-header",
                    icon("plus-circle"),
                    h4("Create New Note")
                ),
                
                fluidRow(
                  column(4,
                         div(class = "form-group",
                             tags$label("Note Type", class = "control-label"),
                             selectInput(ns("new_note_type"), 
                                         label = NULL,
                                         choices = c(
                                           "General Note" = "general",
                                           "Reminder" = "reminder",
                                           "AI Prompt" = "ai"
                                         ),
                                         selected = "general",
                                         width = "100%")
                         )
                  ),
                  column(4,
                         div(id = ns("date_field_container"),
                             div(class = "form-group",
                                 tags$label("Date", class = "control-label"),
                                 dateInput(ns("new_note_date"), 
                                           label = NULL,
                                           value = Sys.Date(),
                                           width = "100%")
                             )
                         )
                  ),
                  column(4,
                         div(class = "form-group",
                             tags$label("Title", class = "control-label"),
                             textInput(ns("new_note_title"),
                                       label = NULL,
                                       placeholder = "Enter title...",
                                       width = "100%")
                         )
                  )
                ),
                
                div(class = "form-group",
                    tags$label("Content", class = "control-label"),
                    textAreaInput(ns("new_note_content"),
                                  label = NULL,
                                  rows = 4,
                                  placeholder = "Write your note content here...",
                                  width = "100%")
                ),
                
                # Button container with uniform buttons
                div(class = "button-container",
                    actionButton(ns("clear_form"), 
                                 HTML("<i class='fa fa-times'></i> Clear"),
                                 class = "btn-secondary-action",
                                 style = "width: auto; padding: 12px 40px;"),
                    actionButton(ns("add_note"), 
                                 HTML("<i class='fa fa-plus-circle'></i> Add Note"),
                                 class = "btn-action",
                                 style = "width: auto; padding: 12px 40px;")
                )
            ),
            
            # Your Notes Section
            div(class = "notes-header",
                icon("sticky-note"),
                h4("Your Notes")
            ),
            
            # Notes Grid
            uiOutput(ns("gallery_grid"))
        )
    ),
    
    # JavaScript for toast notifications
    tags$script(HTML("
      Shiny.addCustomMessageHandler('show-toast', function(message) {
        var existingToast = document.querySelector('.modern-toast');
        if (existingToast) {
          existingToast.remove();
        }
        
        var toast = document.createElement('div');
        toast.className = 'modern-toast ' + message.type;
        toast.innerHTML = '<i class=\"fa ' + message.icon + '\"></i> ' + message.text;
        document.body.appendChild(toast);
        
        setTimeout(function() {
          if (toast && toast.parentNode) {
            toast.style.animation = 'toastSlide 0.3s reverse';
            setTimeout(function() {
              if (toast && toast.parentNode) {
                toast.remove();
              }
            }, 300);
          }
        }, 2000);
      });
      
      // Copy to clipboard
      window.copyToClipboard = function(text) {
        navigator.clipboard.writeText(text).then(function() {});
      };
    "))
  )
}