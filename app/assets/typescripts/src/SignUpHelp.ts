import * as $ from "jquery";

export class SignUpHelp {
	static setupNameSearchClick(selector : string) {
		$(document).on("click", selector, (evt, ele) => {
			$('#help_list').addClass('hide');
			$('#help_search').removeClass('hide');
			$('#help_type').html(ele.id);
			$('#back_to_help').removeClass('hide');
		});
	}

	static setupHelpPlanShoppingClick(selector: string) {
		$(document).on("click", selector, () => {
			$('.help_reset').addClass("hide");
			$('#help_list').removeClass("hide");
			$('#back_to_help').addClass("hide");
		});
	}

	static export() {
          (<any>window).SignUpHelp = SignUpHelp;
	}
}
