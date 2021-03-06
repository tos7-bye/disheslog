require 'rails_helper'

RSpec.describe "Dishes", type: :system do
  let!(:user) { create(:user) }
  let!(:dish) { create(:dish, :picture, user: user) }

  describe "料理登録ページ" do
    before do
      login_for_system(user)
      visit new_dish_path
    end

    context "ページレイアウト" do
      it "料理登録の文字列が存在すること" do
        expect(page).to have_content "料理登録"
      end

      it "正しいタイトルが表示されること" do
        expect(page).to have_title full_title("料理登録")
      end

      it "入力部分に適切なラベルが表示されること" do
        expect(page).to have_content '料理名'
        expect(page).to have_content '説明'
        expect(page).to have_content '分量 [人分]'
        expect(page).to have_content 'コツ・ポイント'
        expect(page).to have_content '作り方参照用URL'
        expect(page).to have_content '所要時間 [分]'
        expect(page).to have_content '人気度 [1~5]'
        expect(page).to have_content 'クックメモ'
      end
    end

    context "料理登録処理" do
      it "有効な情報で登録を行うと料理登録成功のフラッシュが表示されること" do
        fill_in "料理名", with: "イカの塩焼き"
        fill_in "説明", with: "冬に食べたくなる、身体が温まる料理です"
        fill_in "分量", with: 1.5
        fill_in "コツ・ポイント", with: "ピリッと辛めに味付けするのがオススメ"
        fill_in "作り方参照用URL", with: "https://cookpad.com/recipe/2798655"
        fill_in "所要時間", with: 30
        fill_in "人気度", with: 5
        attach_file "dish[picture]", "#{Rails.root}/spec/fixtures/test_dish.jpg"
        click_button "登録する"
        expect(page).to have_content "料理が登録されました！"
      end

      it "画像無しで登録すると、デフォルト画像が割り当てられること" do
        fill_in "料理名", with: "イカの塩焼き"
        click_button "登録する"
        expect(page).to have_link(href: dish_path(Dish.first))
      end

      it "無効な情報で料理登録を行うと料理登録失敗のフラッシュが表示されること" do
        fill_in "料理名", with: ""
        fill_in "説明", with: "冬に食べたくなる、身体が温まる料理です"
        fill_in "分量", with: 1.5
        fill_in "コツ・ポイント", with: "ピリッと辛めに味付けするのがオススメ"
        fill_in "作り方参照用URL", with: "https://cookpad.com/recipe/2798655"
        fill_in "所要時間", with: 30
        fill_in "人気度", with: 5
        click_button "登録する"
        expect(page).to have_content "料理名を入力してください"
      end
    end
  end

  describe "料理編集ページ" do
    before do
      login_for_system(user)
      visit dish_path(dish)
      click_link "編集"
    end

    context "ページレイアウト" do
      it "正しいタイトルが表示されること" do
        expect(page).to have_title full_title('料理情報の編集')
      end

      it "入力部分に適切なラベルが表示されること" do
        expect(page).to have_content '料理名'
        expect(page).to have_content '説明'
        expect(page).to have_content '分量 [人分]'
        expect(page).to have_content 'コツ・ポイント'
        expect(page).to have_content '作り方参照用URL'
        expect(page).to have_content '所要時間 [分]'
        expect(page).to have_content '人気度 [1~5]'
      end
    end

    context "料理の更新処理" do
      it "有効な更新" do
        fill_in "料理名", with: "編集：イカの塩焼き"
        fill_in "説明", with: "編集：冬に食べたくなる、身体が温まる料理です"
        fill_in "分量", with: 3
        fill_in "コツ・ポイント", with: "編集：ピリッと辛めに味付けするのがオススメ"
        fill_in "作り方参照用URL", with: "henshu-https://cookpad.com/recipe/2798655"
        fill_in "所要時間", with: 60
        fill_in "人気度", with: 1
        attach_file "dish[picture]", "#{Rails.root}/spec/fixtures/test_dish2.jpg"
        click_button "更新する"
        expect(page).to have_content "料理情報が更新されました！"
        expect(dish.reload.name).to eq "編集：イカの塩焼き"
        expect(dish.reload.description).to eq "編集：冬に食べたくなる、身体が温まる料理です"
        expect(dish.reload.portion).to eq 3
        expect(dish.reload.tips).to eq "編集：ピリッと辛めに味付けするのがオススメ"
        expect(dish.reload.reference).to eq "henshu-https://cookpad.com/recipe/2798655"
        expect(dish.reload.required_time).to eq 60
        expect(dish.reload.popularity).to eq 1
        expect(dish.reload.picture.url).to include "test_dish2.jpg"
      end

      it "無効な更新" do
        fill_in "料理名", with: ""
        click_button "更新する"
        expect(page).to have_content '料理名を入力してください'
        expect(dish.reload.name).not_to eq ""
      end
    end

    context "料理の削除処理", js: true do
      it "削除成功のフラッシュが表示されること" do
        click_on '削除'
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content '料理が削除されました'
      end
    end
  end

  describe "料理詳細ページ" do
    context "ページレイアウト" do
      before do
        login_for_system(user)
        visit dish_path(dish)
      end

      it "正しいタイトルが表示されること" do
        expect(page).to have_title full_title("#{dish.name}")
      end

      it "料理情報が表示されること" do
        expect(page).to have_content dish.name
        expect(page).to have_content dish.description
        expect(page).to have_content dish.portion
        expect(page).to have_content dish.tips
        expect(page).to have_content dish.reference
        expect(page).to have_content dish.required_time
        expect(page).to have_content dish.popularity
      end
    end

    context "料理の削除", js: true do
      it "削除成功のフラッシュが表示されること" do
        login_for_system(user)
        visit dish_path(dish)
        within find('.change-dish') do
          click_on '削除'
        end
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content '料理が削除されました'
      end
    end
  end
end
