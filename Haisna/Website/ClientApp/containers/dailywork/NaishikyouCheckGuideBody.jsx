import React from 'react';
import PropTypes from 'prop-types';
import { Field } from 'redux-form';
import moment from 'moment';
import styled from 'styled-components';
import { FieldGroup, FieldSet } from '../../components/Field';
import Label from '../../components/control/Label';
import CheckBox from '../../components/control/CheckBox';
import * as constants from '../../constants/common';

const Wrapper = styled.div`
  white-space: nowrap;
  width: 190px;
  background: #ccc;
  margin-right: 5px;
`;

const WrapperField = styled.div`
  width: 130px;
`;

const WrapperField1 = styled.div`
  width: 100px;
`;

const WrapperBlank = styled.div`
  margin-bottom: 20px;
`;

const NaishikyouCheckList = (data) => {
  const { consultdata } = data;
  const { csldate } = consultdata;
  const res = [];

  const Field0 = (
    <FieldSet>
      <Wrapper>
        <Label>ワーファリン</Label>
      </Wrapper>
      <Field component={CheckBox} name="opt_9" checkedValue="4" label="服薬中" />
    </FieldSet>
  );
  const Field1 = (
    <FieldSet>
      <Wrapper>
        <Label>バファリン８１</Label>
      </Wrapper>
      <Field component={CheckBox} name="opt_10" checkedValue="5" label="服薬中" />
    </FieldSet>
  );
  const Field2 = (
    <FieldSet>
      <Wrapper>
        <Label>パナルジン</Label>
      </Wrapper>
      <Field component={CheckBox} name="opt_11" checkedValue="7" label="服薬中" />
    </FieldSet>
  );
  const Field3 = (
    <FieldSet>
      <Wrapper>
        <Label>プレタール</Label>
      </Wrapper>
      <Field component={CheckBox} name="opt_12" checkedValue="3" label="服薬中" />
    </FieldSet>
  );
  const Field4 = (
    <FieldSet>
      <Wrapper>
        <Label>ペルサンチン</Label>
      </Wrapper>
      <Field component={CheckBox} name="opt_13" checkedValue="2" label="服薬中" />
    </FieldSet>
  );
  const Field5 = (
    <FieldSet>
      <Wrapper>
        <Label>アンプラーグ</Label>
      </Wrapper>
      <Field component={CheckBox} name="opt_14" checkedValue="1" label="服薬中" />
    </FieldSet>
  );
  const Field6 = (
    <FieldSet>
      <Wrapper>
        <Label>エパデール</Label>
      </Wrapper>
      <Field component={CheckBox} name="opt_15" checkedValue="6" label="服薬中" />
    </FieldSet>
  );
  const Field7 = (
    <FieldSet>
      <Wrapper>
        <Label>ドルナー・プロサイリン</Label>
      </Wrapper>
      <Field component={CheckBox} name="opt_16" checkedValue="8" label="服薬中" />
    </FieldSet>
  );
  const Field8 = (
    <FieldSet>
      <Wrapper>
        <Label>オパルモン</Label>
      </Wrapper>
      <Field component={CheckBox} name="opt_17" checkedValue="9" label="服薬中" />
    </FieldSet>
  );
  const Field9 = (
    <FieldSet>
      <Wrapper>
        <Label>コメリアン</Label>
      </Wrapper>
      <Field component={CheckBox} name="opt_18" checkedValue="10" label="服薬中" />
    </FieldSet>
  );
  const Field10 = (
    <FieldSet>
      <Wrapper>
        <Label>ロコナール</Label>
      </Wrapper>
      <Field component={CheckBox} name="opt_19" checkedValue="11" label="服薬中" />
    </FieldSet>
  );
  if ((moment(csldate).format('YYYY/MM/DD') >= moment(constants.CHANGE_CSLDATE).format('YYYY/MM/DD')) === false) {
    res.push(<FieldGroup key={1}>{Field0}{Field1}{Field2}{Field3}{Field4}{Field5}{Field6}{Field7}{Field8}{Field9}{Field10}</FieldGroup>);
  }
  return res;
};

class NaishikyouCheckGuideBody extends React.Component {
  // 選択済みをもう一度クリックすると選択解除
  clickRsl = (e, Index) => {
    const { checkitems, setValue } = this.props;
    if (checkitems[Index] === e.target.value) {
      setValue(e.target.name, null);
      checkitems[Index] = null;
    } else {
      checkitems[Index] = e.target.value;
    }
  }

  render() {
    const { consultdata, clickRsl } = this.props;
    const { csldate } = consultdata;
    return (
      <div>
        <FieldGroup>
          <FieldSet>
            <Wrapper>
              <Label>車を運転してきましたか？</Label>
            </Wrapper>
            <WrapperField><Field component="input" type="radio" name="opt_1" value="0" onClick={(e) => this.clickRsl(e, 'opt_1')} /><span>はい</span></WrapperField>
            <WrapperField1><Field component="input" type="radio" name="opt_1" value="1" onClick={(e) => this.clickRsl(e, 'opt_1')} /><span>いいえ</span></WrapperField1>
          </FieldSet>
          <FieldSet>
            <Wrapper>
              <Label>生検組織検査</Label>
            </Wrapper>
            <WrapperField><Field component="input" type="radio" name="opt_2" value="0" onClick={(e) => this.clickRsl(e, 'opt_2')} /><span>必要時同意する</span></WrapperField>
            <WrapperField1><Field component="input" type="radio" name="opt_2" value="1" onClick={(e) => this.clickRsl(e, 'opt_2')} /><span>同意しない</span></WrapperField1>
          </FieldSet>
          <FieldSet>
            <Wrapper>
              <Label>上部消化管内視鏡検査の経験</Label>
            </Wrapper>
            <WrapperField><Field component="input" type="radio" name="opt_3" value="0" onClick={(e) => this.clickRsl(e, 'opt_3')} /><span>あり</span></WrapperField>
            <WrapperField1><Field component="input" type="radio" name="opt_3" value="1" onClick={(e) => this.clickRsl(e, 'opt_3')} /><span>なし</span></WrapperField1>
          </FieldSet>
          <FieldSet>
            <Wrapper>
              <Label>鎮静剤の希望</Label>
            </Wrapper>
            <WrapperField><Field component="input" type="radio" name="opt_4" value="0" onClick={(e) => this.clickRsl(e, 'opt_4')} /><span>あり</span></WrapperField>
            <WrapperField1><Field component="input" type="radio" name="opt_4" value="1" onClick={(e) => this.clickRsl(e, 'opt_4')} /><span>なし</span></WrapperField1>
            <Field component="input" type="radio" name="opt_4" value="2" onClick={(e) => this.clickRsl(e, 'opt_4')} /><span>医師と相談</span>
          </FieldSet>
          <FieldSet>
            <Wrapper>
              <Label>キシロカインアレルギー</Label>
            </Wrapper>
            <WrapperField><Field component="input" type="radio" name="opt_5" value="0" onClick={(e) => this.clickRsl(e, 'opt_5')} /><span>あり</span></WrapperField>
            <WrapperField1><Field component="input" type="radio" name="opt_5" value="1" onClick={(e) => this.clickRsl(e, 'opt_5')} /><span>なし</span></WrapperField1>
          </FieldSet>
          <FieldSet>
            <Wrapper>
              <Label>ヨードアレルギー</Label>
            </Wrapper>
            <WrapperField><Field component="input" type="radio" name="opt_6" value="0" onClick={(e) => this.clickRsl(e, 'opt_6')} /><span>あり</span></WrapperField>
            <WrapperField1><Field component="input" type="radio" name="opt_6" value="1" onClick={(e) => this.clickRsl(e, 'opt_6')} /><span>なし</span></WrapperField1>
          </FieldSet>
          <FieldSet>
            <Wrapper>
              <Label>薬物アレルギー</Label>
            </Wrapper>
            <WrapperField><Field component="input" type="radio" name="opt_7" value="0" onClick={(e) => this.clickRsl(e, 'opt_7')} /><span>あり</span></WrapperField>
            <WrapperField1><Field component="input" type="radio" name="opt_7" value="1" onClick={(e) => this.clickRsl(e, 'opt_7')} /><span>なし</span></WrapperField1>
          </FieldSet>
          {(moment(csldate).format('YYYY/MM/DD') >= moment(constants.CHANGE_CSLDATE).format('YYYY/MM/DD')) === true && (
            <div>
              <FieldSet>
                <Wrapper>
                  <Label>抗凝固剤の使用</Label>
                </Wrapper>
                <WrapperField><Field component="input" type="radio" name="opt_8" value="0" onClick={(e) => this.clickRsl(e, 'opt_8')} /><span>あり</span></WrapperField>
                <WrapperField1><Field component="input" type="radio" name="opt_8" value="1" onClick={(e) => this.clickRsl(e, 'opt_8')} /><span>なし</span></WrapperField1>
              </FieldSet>
              <WrapperBlank />
            </div>
          )}
          {(moment(csldate).format('YYYY/MM/DD') >= moment(constants.CHANGE_CSLDATE).format('YYYY/MM/DD')) === false && (
            <div>
              <FieldSet>
                <Wrapper>
                  <Label>抗凝固剤の使用</Label>
                </Wrapper>
                <WrapperField><Field component="input" type="radio" name="opt_8" value="0" onClick={(e) => this.clickRsl(e, 'opt_8')} /><span>あり</span></WrapperField>
                <WrapperField1><Field component="input" type="radio" name="opt_8" value="1" onClick={(e) => this.clickRsl(e, 'opt_8')} /><span>なし</span></WrapperField1>
                <Field component="input" type="radio" name="opt_8" value="2" onClick={(e) => this.clickRsl(e, 'opt_8')} /><span>休薬中</span>
              </FieldSet>
              <WrapperBlank />
            </div>
          )}
        </FieldGroup>
        <NaishikyouCheckList consultdata={consultdata} clickRsl={clickRsl} />
      </div>
    );
  }
}


// propTypesの定義
NaishikyouCheckGuideBody.propTypes = {
  consultdata: PropTypes.shape().isRequired,
  setValue: PropTypes.func.isRequired,
  clickRsl: PropTypes.func,
  checkitems: PropTypes.shape().isRequired,
};

// defaultPropsの定義
NaishikyouCheckGuideBody.defaultProps = {
  clickRsl: undefined,
};

export default NaishikyouCheckGuideBody;
